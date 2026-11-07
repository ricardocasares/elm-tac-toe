module MainSpec exposing (suite)

import Expect exposing (Expectation)
import Html.Attributes as Attr
import Main exposing (Model, Msg)
import Test exposing (Test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


render : Model -> Query.Single Msg
render model =
    Query.fromHtml (Main.view model)


cellSelector : String -> Selector.Selector
cellSelector label =
    Selector.attribute (Attr.attribute "aria-label" label)


{-| Clicks whatever the rendered page offers under this selector, like a user
would, so a disabled button or a missing element fails the test.
-}
click : Selector.Selector -> Model -> Result String Model
click selector model =
    render model
        |> Query.find [ Selector.tag "button", selector ]
        |> Event.simulate Event.click
        |> Event.toResult
        |> Result.map (\msg -> Main.update msg model)


clickAll : List String -> Result String Model
clickAll labels =
    List.foldl
        (\label -> Result.andThen (click (cellSelector label)))
        (Ok Main.init)
        labels


expectStatus : String -> Result String Model -> Expectation
expectStatus expected result =
    case result of
        Ok model ->
            render model
                |> Query.find [ Selector.attribute (Attr.attribute "role" "status") ]
                |> Query.has [ Selector.text expected ]

        Err message ->
            Expect.fail message


expectCell : String -> (Query.Single Msg -> Expectation) -> Result String Model -> Expectation
expectCell label expectation result =
    case result of
        Ok model ->
            render model
                |> Query.find [ Selector.tag "button", cellSelector label ]
                |> expectation

        Err message ->
            Expect.fail message


xWinsTopRow : List String
xWinsTopRow =
    [ "Row 1, column 1: empty"
    , "Row 2, column 1: empty"
    , "Row 1, column 2: empty"
    , "Row 2, column 2: empty"
    , "Row 1, column 3: empty"
    ]


suite : Test
suite =
    Test.describe "Main"
        [ Test.test "the page opens with nine empty cells and X to move" <|
            \_ ->
                Expect.all
                    [ Query.findAll [ Selector.tag "button", Selector.attribute (Attr.disabled False) ]
                        >> Query.count (Expect.atLeast 9)
                    , Query.find [ Selector.attribute (Attr.attribute "role" "status") ]
                        >> Query.has [ Selector.text "X to move" ]
                    ]
                    (render Main.init)
        , Test.test "every cell has its own label" <|
            \_ ->
                render Main.init
                    |> Query.has
                        (List.concatMap
                            (\row ->
                                List.map
                                    (\column ->
                                        cellSelector ("Row " ++ String.fromInt row ++ ", column " ++ String.fromInt column ++ ": empty")
                                    )
                                    [ 1, 2, 3 ]
                            )
                            [ 1, 2, 3 ]
                        )
        , Test.test "clicking a cell marks it and passes the turn" <|
            \_ ->
                clickAll [ "Row 2, column 2: empty" ]
                    |> Expect.all
                        [ expectStatus "O to move"
                        , expectCell "Row 2, column 2: X" (Query.has [ Selector.disabled True ])
                        ]
        , Test.test "a win is announced and every cell locks" <|
            \_ ->
                clickAll xWinsTopRow
                    |> Expect.all
                        [ expectStatus "X wins"
                        , expectCell "Row 3, column 3: empty" (Query.has [ Selector.disabled True ])
                        ]
        , Test.test "the winning cells are highlighted and the others are not" <|
            \_ ->
                clickAll xWinsTopRow
                    |> Expect.all
                        [ expectCell "Row 1, column 1: X" (Query.has [ Selector.class "!bg-success" ])
                        , expectCell "Row 1, column 2: X" (Query.has [ Selector.class "!bg-success" ])
                        , expectCell "Row 1, column 3: X" (Query.has [ Selector.class "!bg-success" ])
                        , expectCell "Row 2, column 1: O" (Query.hasNot [ Selector.class "!bg-success" ])
                        ]
        , Test.test "a full board with no line is announced as a draw" <|
            \_ ->
                clickAll
                    [ "Row 1, column 1: empty"
                    , "Row 1, column 2: empty"
                    , "Row 1, column 3: empty"
                    , "Row 2, column 2: empty"
                    , "Row 2, column 1: empty"
                    , "Row 2, column 3: empty"
                    , "Row 3, column 2: empty"
                    , "Row 3, column 1: empty"
                    , "Row 3, column 3: empty"
                    ]
                    |> expectStatus "Draw"
        , Test.test "New game works mid-game and clears the board" <|
            \_ ->
                clickAll [ "Row 1, column 1: empty", "Row 1, column 2: empty" ]
                    |> Result.andThen (click (Selector.containing [ Selector.text "New game" ]))
                    |> Expect.equal (Ok Main.init)
        , Test.test "New game works after a win" <|
            \_ ->
                clickAll xWinsTopRow
                    |> Result.andThen (click (Selector.containing [ Selector.text "New game" ]))
                    |> Expect.equal (Ok Main.init)
        ]
