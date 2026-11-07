module Main exposing (Model, Msg, init, main, update, view)

import Browser
import Game exposing (Cell(..), Game, Player(..), Status(..))
import Html exposing (Html, button, div, input, li, span, text, ul)
import Html.Attributes as Attr exposing (class, classList, disabled)
import Html.Events exposing (onClick)
import Icons


type alias Model =
    Game


type Msg
    = Reset
    | CellClicked Int


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    Game.new


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reset ->
            init

        CellClicked cell ->
            Game.play cell model


view : Model -> Html Msg
view model =
    div [ class "flex flex-col h-full" ]
        [ div
            [ class "navbar bg-base-300"
            ]
            [ div
                [ class "navbar-start"
                ]
                [ statusView (Game.status model) ]
            , div
                [ class "navbar-end"
                ]
                [ button [ class "btn btn-accent", onClick Reset ] [ text "New game" ]
                , themeSelector
                ]
            ]
        , div
            -- The largest square that fits under the 4.5rem navbar, so nothing scrolls.
            [ class "mx-auto aspect-square w-[min(100vw,calc(100dvh-4.5rem))] grid grid-cols-3 grid-rows-3 gap-2 p-2" ]
            (boardView model)
        ]


statusView : Status -> Html msg
statusView status =
    div
        [ class "flex gap-2 items-center px-4 text-xl font-semibold"
        , Attr.attribute "role" "status"
        ]
        (case status of
            Playing player ->
                [ playerView player, text (playerName player ++ " to move") ]

            Won player _ ->
                [ playerView player, text (playerName player ++ " wins") ]

            Draw ->
                [ text "Draw" ]
        )


boardView : Game -> List (Html Msg)
boardView game =
    let
        status : Status
        status =
            Game.status game
    in
    List.indexedMap (cellView status) (Game.board game)


cellView : Status -> Int -> Cell -> Html Msg
cellView status index cell =
    let
        ( isOver, isWinning ) =
            case status of
                Playing _ ->
                    ( False, False )

                Won _ winningCells ->
                    ( True, List.member index winningCells )

                Draw ->
                    ( True, False )
    in
    button
        [ class "btn h-full [&_svg]:size-16 sm:[&_svg]:size-24"
        , classList
            [ ( "bg-accent", not isOver )
            , ( "!bg-success", isWinning )
            , ( "opacity-50", isOver && not isWinning )
            ]
        , Attr.attribute "aria-label" (cellLabel index cell)
        , onClick (CellClicked index)
        , disabled (cell /= Blank || isOver)
        ]
        [ cellContent cell ]


cellLabel : Int -> Cell -> String
cellLabel index cell =
    "Row "
        ++ String.fromInt (index // 3 + 1)
        ++ ", column "
        ++ String.fromInt (modBy 3 index + 1)
        ++ ": "
        ++ (case cell of
                Blank ->
                    "empty"

                Taken player ->
                    playerName player
           )


cellContent : Cell -> Html msg
cellContent cell =
    case cell of
        Taken player ->
            playerView player

        Blank ->
            text ""


playerName : Player -> String
playerName player =
    case player of
        X ->
            "X"

        O ->
            "O"


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
