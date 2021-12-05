module Day4 exposing (main, parse, puzzleInput, solution1, solution2, solve1, solve2)

import Html exposing (Html)


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


parse : String -> List (List Int)
parse string =
    [ [ 1 ] ]


solve1 : List (List Int) -> Int
solve1 ints =
    42


solve2 : List (List Int) -> Int
solve2 ints =
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
