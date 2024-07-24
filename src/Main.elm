module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, li, span, text, ul)
import Html.Attributes as Attr exposing (class, disabled)
import Html.Events exposing (onClick)
import Icons


type Player
    = X
    | O


type Cell
    = Blank
    | Taken Player


type alias Board =
    List Cell


type Game
    = On
    | Draw
    | Won Player


type alias Model =
    { game : Game
    , turn : Player
    , board : Board
    }


type Msg
    = Reset
    | CellClicked Int


winningConfigs : List (List number)
winningConfigs =
    [ [ 0, 1, 2 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 2, 4, 6 ]
    , [ 0, 4, 8 ]
    ]


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    { turn = X
    , game = On
    , board = List.repeat 9 Blank
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reset ->
            init

        CellClicked cell ->
            model
                |> updateBoard cell
                |> updateGame
                |> changeTurn


view : Model -> Html Msg
view model =
    div [ class "flex flex-col h-full" ]
        [ div
            [ class "navbar bg-base-300"
            ]
            [ div
                [ class "navbar-start"
                ]
                [ span [ class "btn btn-ghost text-xl" ]
                    [ case model.game of
                        On ->
                            div [] [ text "TicTacToe" ]

                        Draw ->
                            div [] [ text "Draw" ]

                        Won player ->
                            div [ class "flex gap-2 items-center" ]
                                [ blankOrPlayer (Taken player)
                                , text "Wins"
                                ]
                    ]
                ]
            , div
                [ class "navbar-end"
                ]
                [ button [ class "btn btn-accent", onClick Reset, disabled (model.game == On) ] [ text "Play again" ]
                , themeSelector
                ]
            ]
        , div [ class "flex aspect-square grid grid-cols-3 grid-rows-3 gap-2 p-2" ] (boardView model)
        ]


boardView : Model -> List (Html Msg)
boardView model =
    List.indexedMap (\a b -> cellView b (enabledCell model b) (CellClicked a)) model.board


enabledCell : Model -> Cell -> Bool
enabledCell m c =
    c /= Blank || m.game /= On


cellView : Cell -> Bool -> msg -> Html msg
cellView cell taken msg =
    button
        [ class "text-[6rem] btn h-full align-middle"
        , class "bg-accent font-mono leading-10"
        , Attr.attribute "aria-label" "Cell"
        , onClick msg
        , disabled taken
        ]
        [ blankOrPlayer cell ]


blankOrPlayer : Cell -> Html msg
blankOrPlayer cell =
    case cell of
        Taken p ->
            playerView p

        Blank ->
            text ""


changeTurn : Model -> Model
changeTurn model =
    case model.turn of
        X ->
            { model | turn = O }

        O ->
            { model | turn = X }


updateGame : Model -> Model
updateGame model =
    let
        moves : List Int
        moves =
            List.foldr (listOfMovesIndexes model.turn) [] (List.indexedMap Tuple.pair model.board)

        hasWon : Bool
        hasWon =
            compareMovesAgainstWinningConfigs moves
    in
    if hasWon then
        { model | game = Won model.turn }

    else if List.length moves == 5 then
        { model | game = Draw }

    else
        model


compareMovesAgainstWinningConfigs : List Int -> Bool
compareMovesAgainstWinningConfigs moves =
    List.any (\cfg -> List.all (\move -> List.member move moves) cfg) winningConfigs


listOfMovesIndexes : Player -> ( Int, Cell ) -> List Int -> List Int
listOfMovesIndexes player ( idx, cell ) list =
    if cell == Taken player then
        idx :: list

    else
        list


updateBoard : Int -> Model -> Model
updateBoard cell model =
    { model
        | board =
            List.indexedMap
                (\a b ->
                    if a == cell && b == Blank then
                        Taken model.turn

                    else
                        b
                )
                model.board
    }


playerView : Player -> Html msg
playerView player =
    case player of
        O ->
            span [ class "text-primary" ] [ Icons.o ]

        X ->
            span [ class "text-secondary" ] [ Icons.x ]


themeSelector : Html msg
themeSelector =
    button
        [ Attr.class "dropdown dropdown-end"
        , Attr.attribute "aria-label" "Theme selector"
        ]
        [ div
            [ Attr.tabindex 0
            , Attr.attribute "role" "button"
            , Attr.class "btn btn-ghost m-1"
            , Attr.attribute "aria-label" "Theme selector"
            ]
            [ Icons.themes
            , Icons.arrow
            ]
        , ul
            [ Attr.tabindex 0
            , Attr.class "dropdown-content bg-base-300 rounded z-[1] w-52 p-2 shadow-2xl"
            ]
            [ li []
                [ input
                    [ Attr.type_ "radio"
                    , Attr.name "theme-dropdown"
                    , Attr.class "theme-controller btn btn-block btn-ghost justify-start"
                    , Attr.attribute "aria-label" "Light"
                    , Attr.value "light"
                    ]
                    []
                ]
            , li []
                [ input
                    [ Attr.type_ "radio"
                    , Attr.name "theme-dropdown"
                    , Attr.class "theme-controller btn btn-block btn-ghost justify-start"
                    , Attr.attribute "aria-label" "Cyberpunk"
                    , Attr.value "cyberpunk"
                    ]
                    []
                ]
            , li []
                [ input
                    [ Attr.type_ "radio"
                    , Attr.name "theme-dropdown"
                    , Attr.class "theme-controller btn btn-block btn-ghost justify-start"
                    , Attr.attribute "aria-label" "Wireframe"
                    , Attr.value "wireframe"
                    ]
                    []
                ]
            , li []
                [ input
                    [ Attr.type_ "radio"
                    , Attr.name "theme-dropdown"
                    , Attr.class "theme-controller btn btn-block btn-ghost justify-start"
                    , Attr.attribute "aria-label" "Dracula"
                    , Attr.value "dracula"
                    ]
                    []
                ]
            , li []
                [ input
                    [ Attr.type_ "radio"
                    , Attr.name "theme-dropdown"
                    , Attr.class "theme-controller btn btn-block btn-ghost justify-start"
                    , Attr.attribute "aria-label" "Black"
                    , Attr.value "black"
                    ]
                    []
                ]
            ]
        ]
