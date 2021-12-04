module Day3 exposing (..)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, Step(..), Trailing(..), chompIf, chompUntil, int, keyword, loop, oneOf, spaces, succeed)


type alias Reading =
    { pos1 : Int, pos2 : Int }


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1
        |> (\powerConsumption -> powerConsumption.gamma * powerConsumption.epsilon)


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2
        |> (\position -> position.horizontal * position.depth)


parse : String -> List Reading
parse string =
    case Parser.run readingParser string of
        Ok value ->
            value

        Err _ ->
            []


readingParser : Parser (List Reading)
readingParser =
    loop [] commandParserHelper


commandParserHelper : List Reading -> Parser (Step (List Reading) (List Reading))
commandParserHelper reversedList =
    oneOf
        [ succeed (\command -> Loop (command :: reversedList))
            |. spaces
            |= parseReading
            |. chompUntil "\n"
            |. spaces
        , succeed ()
            |> Parser.map (\_ -> Done (List.reverse reversedList))
        ]


parseReading : Parser Reading
parseReading =
    succeed Reading
        |= Parser.int
        |= Parser.int


type alias PowerConsumption =
    { gamma : Int
    , epsilon : Int
    }


type alias Position2 =
    { horizontal : Int
    , depth : Int
    , aim : Int
    }


type alias Accumulator =
    { pos1 : Int
    , pos2 : Int
    }


solve1 : List Reading -> PowerConsumption
solve1 readings =
    List.foldl foo (Accumulator 0 0) readings
        |> accToPo
            PowerConsumption
            0
            0


solve2 : List Reading -> Position2
solve2 commands =
    Position2 0 0 0


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
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
"""
