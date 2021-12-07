module Day5 exposing (..)

import Html exposing (Html)


type alias Plan =
    List EndPoint


type alias EndPoint =
    { x1 : Int
    , y1 : Int
    , x2 : Int
    , y2 : Int
    }


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2


parse : String -> Plan
parse _ =
    []


solve1 : Plan -> Int
solve1 _ =
    42


solve2 : Plan -> Int
solve2 _ =
    4711


main : Html Never
main =
    Html.div []
        [ Html.p []
            [ Html.text (String.fromInt (solution1 puzzleInput))
            ]
        , Html.p [] [ Html.text (String.fromInt (solution2 puzzleInput)) ]
        ]


puzzleInput : String
puzzleInput =
    """
    
    """
