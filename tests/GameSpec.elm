module GameSpec exposing (suite)

import Expect
import Fuzz
import Game exposing (Cell(..), Game, Player(..), Status(..))
import Test exposing (Test)


playAll : List Int -> Game
playAll moves =
    List.foldl Game.play Game.new moves


allLines : List (List Int)
allLines =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 0, 4, 8 ]
    , [ 2, 4, 6 ]
    ]


{-| Interleaves two players' moves, starting with X.
-}
interleave : List Int -> List Int -> List Int
interleave xs os =
    case ( xs, os ) of
        ( x :: restX, o :: restO ) ->
            x :: o :: interleave restX restO

        _ ->
            xs ++ os


offLine : List Int -> List Int
offLine line =
    List.filter (\cell -> not (List.member cell line)) (List.range 0 8)


type alias Tally =
    { games : Int
    , xWins : Int
    , oWins : Int
    , draws : Int
    }


{-| Plays out every legal continuation of a game and counts how each one ends.
-}
tallyFrom : Game -> Tally -> Tally
tallyFrom game tally =
    case Game.status game of
        Won X _ ->
            { tally | games = tally.games + 1, xWins = tally.xWins + 1 }

        Won O _ ->
            { tally | games = tally.games + 1, oWins = tally.oWins + 1 }

        Draw ->
            { tally | games = tally.games + 1, draws = tally.draws + 1 }

        Playing _ ->
            List.foldl
                (\cell acc -> tallyFrom (Game.play cell game) acc)
                tally
                (blankCells game)


blankCells : Game -> List Int
blankCells game =
    Game.board game
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, cell ) -> cell == Blank)
        |> List.map Tuple.first


suite : Test
suite =
    Test.describe "Game"
        [ Test.test "a new game is an empty board with X to move" <|
            \_ ->
                Expect.all
                    [ Game.board >> Expect.equal (List.repeat 9 Blank)
                    , Game.status >> Expect.equal (Playing X)
                    ]
                    Game.new
        , Test.test "a move fills the chosen cell and passes the turn" <|
            \_ ->
                Expect.all
                    [ Game.board >> List.drop 4 >> List.head >> Expect.equal (Just (Taken X))
                    , Game.board >> List.filter ((/=) Blank) >> List.length >> Expect.equal 1
                    , Game.status >> Expect.equal (Playing O)
                    ]
                    (playAll [ 4 ])
        , Test.test "players alternate" <|
            \_ ->
                playAll [ 0, 1 ]
                    |> Game.board
                    |> List.take 2
                    |> Expect.equal [ Taken X, Taken O ]
        , Test.test "playing a taken cell changes nothing and keeps the turn" <|
            \_ ->
                playAll [ 0, 0 ]
                    |> Expect.equal (playAll [ 0 ])
        , Test.fuzz (Fuzz.oneOf [ Fuzz.intRange -1000 -1, Fuzz.intRange 9 1000 ]) "an index off the board changes nothing" <|
            \index ->
                Game.play index Game.new
                    |> Expect.equal Game.new
        , Test.describe "X wins on every line"
            (List.map
                (\line ->
                    Test.test (Debug.toString line) <|
                        \_ ->
                            interleave line (List.take 2 (offLine line))
                                |> playAll
                                |> Game.status
                                |> Expect.equal (Won X line)
                )
                allLines
            )
        , Test.describe "O wins on every line"
            (List.map
                (\line ->
                    Test.test (Debug.toString line) <|
                        \_ ->
                            let
                                others : List Int
                                others =
                                    offLine line
                            in
                            -- First, second and last cell off the line never form a line themselves.
                            interleave (List.take 2 others ++ List.drop 5 others) line
                                |> playAll
                                |> Game.status
                                |> Expect.equal (Won O line)
                )
                allLines
            )
        , Test.test "a win on the ninth move is a win, not a draw" <|
            \_ ->
                playAll [ 0, 1, 2, 3, 4, 5, 7, 6, 8 ]
                    |> Game.status
                    |> Expect.equal (Won X [ 0, 4, 8 ])
        , Test.test "one move completing two lines reports every winning cell" <|
            \_ ->
                playAll [ 1, 4, 2, 5, 3, 7, 6, 8, 0 ]
                    |> Game.status
                    |> Expect.equal (Won X [ 0, 1, 2, 3, 6 ])
        , Test.test "a full board with no line is a draw" <|
            \_ ->
                playAll [ 0, 1, 2, 4, 3, 5, 7, 6, 8 ]
                    |> Game.status
                    |> Expect.equal Draw
        , Test.test "no move is accepted after a win" <|
            \_ ->
                playAll [ 0, 3, 1, 4, 2, 8 ]
                    |> Expect.equal (playAll [ 0, 3, 1, 4, 2 ])
        , Test.test "every possible game ends as the known totals say it should" <|
            \_ ->
                tallyFrom Game.new { games = 0, xWins = 0, oWins = 0, draws = 0 }
                    |> Expect.equal { games = 255168, xWins = 131184, oWins = 77904, draws = 46080 }
        ]
