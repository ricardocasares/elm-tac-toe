module Game exposing (Cell(..), Game, Player(..), Status(..), board, new, play, status)

{-| The rules of tic-tac-toe, with no UI in sight.

`Game` is opaque so the only way to change one is through `play`, which keeps
the board and the status consistent with each other.

Cells are numbered left to right, top to bottom:

    0 1 2

    3 4 5

    6 7 8

-}

import Array exposing (Array)


type Player
    = X
    | O


type Cell
    = Blank
    | Taken Player


{-| `Playing` holds whose turn it is. `Won` holds the winner and the sorted
indexes of every cell in a completed line. A single move can complete two lines
at once, so that list can be longer than three.
-}
type Status
    = Playing Player
    | Won Player (List Int)
    | Draw


type Game
    = Game
        { cells : Array Cell
        , status : Status
        }


size : Int
size =
    9


lines : List (List Int)
lines =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 0, 4, 8 ]
    , [ 2, 4, 6 ]
    ]


{-| An empty board with X to move.
-}
new : Game
new =
    Game
        { cells = Array.repeat size Blank
        , status = Playing X
        }


board : Game -> List Cell
board (Game game) =
    Array.toList game.cells


status : Game -> Status
status (Game game) =
    game.status


{-| The current player takes a cell. The game comes back unchanged if the game
is over, the cell is taken, or the index is off the board.
-}
play : Int -> Game -> Game
play index (Game game) =
    case game.status of
        Playing player ->
            if Array.get index game.cells == Just Blank then
                let
                    cells : Array Cell
                    cells =
                        Array.set index (Taken player) game.cells
                in
                Game { cells = cells, status = statusAfterMove player cells }

            else
                Game game

        _ ->
            Game game


statusAfterMove : Player -> Array Cell -> Status
statusAfterMove player cells =
    let
        completed : List (List Int)
        completed =
            List.filter (List.all (\index -> Array.get index cells == Just (Taken player))) lines
    in
    if not (List.isEmpty completed) then
        Won player (List.filter (\index -> List.any (List.member index) completed) (List.range 0 (size - 1)))

    else if List.member Blank (Array.toList cells) then
        Playing (opponent player)

    else
        Draw


opponent : Player -> Player
opponent player =
    case player of
        X ->
            O

        O ->
            X
