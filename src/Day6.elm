module Day6 exposing
    ( main
    , model
    , parse
    , puzzleInput
    , solution1
    , solution2
    , solve1
    , solve2
    )

import Html exposing (Html)
import Parser exposing ((|=), Parser, Trailing(..), int, spaces, succeed)


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


parse : String -> List Int
parse string =
    case Parser.run parseInts <| String.trim string of
        Ok result ->
            result

        Err _ ->
            Debug.todo "parse error"


parseInts : Parser (List Int)
parseInts =
    succeed identity
        |= Parser.sequence
            { start = ""
            , end = ""
            , separator = ","
            , spaces = spaces
            , item = int
            , trailing = Optional
            }


solve1 : List Int -> Int
solve1 ints =
    model ints 80


solve2 : List Int -> Int
solve2 _ =
    4711


model : List Int -> Int -> Int
model current days =
    if days <= 0 then
        List.length current

    else
        let
            parents =
                current |> List.filter (\n -> n == 0) |> List.length

            tick n =
                if n == 0 then
                    6

                else
                    n - 1

            nextDay =
                List.append (List.map tick current) (List.repeat parents 8)
        in
        model nextDay (days - 1)


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
1,3,3,4,5,1,1,1,1,1,1,2,1,4,1,1,1,5,2,2,4,3,1,1,2,5,4,2,2,3,1,2,3,2,1,1,4,4,2,4,4,1,2,4,3,3,3,1,1,3,4,5,2,5,1,2,5,1,1,1,3,2,3,3,1,4,1,1,4,1,4,1,1,1,1,5,4,2,1,2,2,5,5,1,1,1,1,2,1,1,1,1,3,2,3,1,4,3,1,1,3,1,1,1,1,3,3,4,5,1,1,5,4,4,4,4,2,5,1,1,2,5,1,3,4,4,1,4,1,5,5,2,4,5,1,1,3,1,3,1,4,1,3,1,2,2,1,5,1,5,1,3,1,3,1,4,1,4,5,1,4,5,1,1,5,2,2,4,5,1,3,2,4,2,1,1,1,2,1,2,1,3,4,4,2,2,4,2,1,4,1,3,1,3,5,3,1,1,2,2,1,5,2,1,1,1,1,1,5,4,3,5,3,3,1,5,5,4,4,2,1,1,1,2,5,3,3,2,1,1,1,5,5,3,1,4,4,2,4,2,1,1,1,5,1,2,4,1,3,4,4,2,1,4,2,1,3,4,3,3,2,3,1,5,3,1,1,5,1,2,2,4,4,1,2,3,1,2,1,1,2,1,1,1,2,3,5,5,1,2,3,1,3,5,4,2,1,3,3,4
"""
