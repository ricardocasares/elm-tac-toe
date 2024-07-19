module Icons exposing (arrow, o, themes, x)

import Html exposing (Html)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


x : Html msg
x =
    svg
        [ SvgAttr.width "32"
        , SvgAttr.height "32"
        , SvgAttr.viewBox "0 0 24 24"
        ]
        [ path
            [ SvgAttr.fill "none"
            , SvgAttr.stroke "currentColor"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.d "M18 6L6 18M6 6l12 12"
            ]
            []
        ]


o : Html msg
o =
    svg
        [ SvgAttr.width "32"
        , SvgAttr.height "32"
        , SvgAttr.viewBox "0 0 24 24"
        ]
        [ Svg.circle
            [ SvgAttr.cx "12"
            , SvgAttr.cy "12"
            , SvgAttr.r "10"
            , SvgAttr.fill "none"
            , SvgAttr.stroke "currentColor"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            ]
            []
        ]


arrow : Html msg
arrow =
    svg
        [ SvgAttr.width "12px"
        , SvgAttr.height "12px"
        , SvgAttr.class "inline-block h-2 w-2 fill-current opacity-60"
        , SvgAttr.viewBox "0 0 2048 2048"
        ]
        [ path
            [ SvgAttr.d "M1799 349l242 241-1017 1017L7 590l242-241 775 775 775-775z"
            ]
            []
        ]


themes : Html msg
themes =
    svg
        [ SvgAttr.width "16"
        , SvgAttr.height "16"
        , SvgAttr.viewBox "0 0 24 24"
        ]
        [ Svg.g
            [ SvgAttr.fill "none"
            , SvgAttr.stroke "currentColor"
            , SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            ]
            [ Svg.circle
                [ SvgAttr.cx "13.5"
                , SvgAttr.cy "6.5"
                , SvgAttr.r ".5"
                , SvgAttr.fill "currentColor"
                ]
                []
            , Svg.circle
                [ SvgAttr.cx "17.5"
                , SvgAttr.cy "10.5"
                , SvgAttr.r ".5"
                , SvgAttr.fill "currentColor"
                ]
                []
            , Svg.circle
                [ SvgAttr.cx "8.5"
                , SvgAttr.cy "7.5"
                , SvgAttr.r ".5"
                , SvgAttr.fill "currentColor"
                ]
                []
            , Svg.circle
                [ SvgAttr.cx "6.5"
                , SvgAttr.cy "12.5"
                , SvgAttr.r ".5"
                , SvgAttr.fill "currentColor"
                ]
                []
            , path
                [ SvgAttr.d "m19 11l-8-8l-8.6 8.6a2 2 0 0 0 0 2.8l5.2 5.2c.8.8 2 .8 2.8 0zM5 2l5 5m-8 6h15m5 7a2 2 0 1 1-4 0c0-1.6 1.7-2.4 2-4c.3 1.6 2 2.4 2 4"
                ]
                []
            ]
        ]
