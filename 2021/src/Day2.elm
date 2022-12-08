module Day2 exposing (Command(..), Position1, Position2, main, parse, solution1, solution2)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, Step(..), chompUntil, int, keyword, loop, oneOf, spaces, succeed)


type Command
    = Forward Int
    | Down Int
    | Up Int


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1
        |> (\position -> position.horizontal * position.depth)


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2
        |> (\position -> position.horizontal * position.depth)


parse : String -> List Command
parse string =
    case Parser.run commandParser string of
        Ok value ->
            value

        Err _ ->
            []


commandParser : Parser (List Command)
commandParser =
    loop [] commandParserHelper


commandParserHelper : List Command -> Parser (Step (List Command) (List Command))
commandParserHelper reversedList =
    oneOf
        [ succeed (\command -> Loop (command :: reversedList))
            |. spaces
            |= parseCommand
            |. chompUntil "\n"
            |. spaces
        , succeed ()
            |> Parser.map (\_ -> Done (List.reverse reversedList))
        ]


parseCommand : Parser Command
parseCommand =
    oneOf
        [ succeed Forward
            |. keyword "forward"
            |. spaces
            |= int
        , succeed Down
            |. keyword "down"
            |. spaces
            |= int
        , succeed Up
            |. keyword "up"
            |. spaces
            |= int
        ]


type alias Position1 =
    { horizontal : Int
    , depth : Int
    }


type alias Position2 =
    { horizontal : Int
    , depth : Int
    , aim : Int
    }


solve1 : List Command -> Position1
solve1 commands =
    List.foldl nextPos1 (Position1 0 0) commands


nextPos1 : Command -> Position1 -> Position1
nextPos1 command position =
    case command of
        Forward int ->
            { position | horizontal = position.horizontal + int }

        Down int ->
            { position | depth = position.depth + int }

        Up int ->
            { position | depth = position.depth - int }


solve2 : List Command -> Position2
solve2 commands =
    List.foldl nextPos2 (Position2 0 0 0) commands


nextPos2 : Command -> Position2 -> Position2
nextPos2 command position =
    case command of
        Forward int ->
            { position
                | horizontal = position.horizontal + int
                , depth = position.aim * int + position.depth
            }

        Down int ->
            { position | aim = position.aim + int }

        Up int ->
            { position | aim = position.aim - int }


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
forward 4
down 9
forward 6
down 5
up 2
forward 5
forward 7
up 5
down 9
up 6
down 6
down 1
down 1
up 2
down 3
up 3
forward 8
forward 7
down 6
down 7
forward 6
forward 9
forward 7
up 9
down 4
down 6
down 5
down 9
forward 8
down 9
forward 9
forward 4
forward 4
up 3
up 8
down 9
down 8
down 4
forward 5
forward 4
up 6
forward 6
up 3
up 8
up 3
up 4
down 3
down 5
down 5
up 1
forward 9
down 4
forward 6
down 6
up 2
up 9
forward 1
forward 2
forward 7
down 6
up 6
forward 1
forward 7
down 7
forward 9
forward 4
forward 6
down 5
up 9
down 1
up 5
up 5
up 9
down 5
forward 7
down 1
up 9
down 7
forward 2
down 4
down 4
forward 8
forward 8
down 6
down 3
up 7
down 3
forward 9
down 7
forward 2
down 1
forward 5
up 9
down 2
up 2
down 3
up 7
forward 9
forward 7
down 4
down 5
up 3
down 3
down 5
forward 9
down 3
forward 9
down 3
up 9
down 5
forward 4
down 4
up 8
forward 7
up 1
down 2
forward 4
down 7
down 9
down 4
down 4
forward 6
down 7
down 2
down 1
forward 1
down 2
forward 1
down 7
forward 5
up 3
forward 6
up 9
down 3
down 3
down 9
forward 4
down 4
forward 9
forward 6
down 7
up 9
up 6
forward 4
down 5
forward 2
down 7
down 7
forward 4
forward 5
down 8
down 5
up 4
forward 7
up 8
down 8
forward 4
forward 5
down 6
down 1
down 1
down 9
forward 4
up 1
down 8
up 7
down 1
up 2
forward 4
down 7
down 7
down 2
forward 7
down 2
up 1
up 4
down 6
forward 5
forward 2
up 1
forward 2
forward 9
up 9
up 7
forward 9
down 8
up 5
down 6
down 6
up 8
down 1
forward 6
down 5
forward 2
down 9
down 9
up 4
forward 4
forward 2
forward 7
forward 3
down 1
forward 8
up 9
down 7
forward 9
forward 1
forward 5
up 6
down 6
forward 6
up 3
forward 9
down 3
forward 2
down 7
down 3
up 9
down 2
down 3
forward 5
down 9
forward 8
down 2
forward 1
down 9
down 7
forward 2
forward 6
forward 4
forward 5
down 5
down 1
forward 5
up 4
down 4
up 8
down 4
up 4
down 1
down 2
down 9
down 2
up 4
down 1
forward 2
forward 1
forward 9
down 5
up 4
up 1
forward 8
forward 6
forward 9
up 9
forward 4
forward 4
down 1
forward 6
forward 7
forward 3
up 5
up 7
down 1
forward 4
down 3
down 5
up 7
down 4
up 9
down 3
down 5
forward 7
forward 8
up 5
up 1
forward 3
up 8
forward 3
down 2
forward 1
forward 9
forward 1
down 2
forward 7
down 5
forward 6
down 9
up 9
forward 5
forward 7
forward 6
down 2
up 2
forward 3
forward 4
forward 3
down 5
forward 1
forward 2
forward 6
down 4
forward 2
forward 6
up 8
forward 2
up 4
forward 7
down 2
forward 1
forward 7
down 6
forward 4
down 3
down 2
down 2
forward 4
down 8
forward 6
forward 6
down 2
up 3
up 1
forward 1
down 5
down 2
forward 4
forward 7
forward 3
down 3
forward 9
down 1
down 7
forward 6
forward 1
up 6
forward 7
forward 1
down 5
down 4
forward 6
up 1
down 1
up 9
down 2
down 2
forward 3
up 4
down 5
down 5
down 3
down 6
up 8
forward 2
forward 2
down 6
down 1
up 4
up 1
down 5
up 4
up 2
forward 4
forward 6
forward 3
down 7
forward 8
up 5
forward 5
down 1
forward 2
forward 6
down 8
up 6
down 1
down 7
forward 4
forward 2
up 1
down 6
forward 3
forward 1
forward 5
forward 9
forward 9
down 4
forward 2
down 1
forward 1
forward 7
forward 5
down 9
down 8
down 1
down 6
down 1
up 7
down 3
forward 3
up 6
up 4
down 7
down 7
forward 6
up 7
down 7
forward 9
down 9
down 3
forward 6
forward 9
forward 1
down 4
forward 5
down 4
down 2
down 3
up 3
forward 9
forward 7
forward 5
down 5
forward 7
up 4
down 1
forward 3
down 3
forward 4
down 9
forward 2
down 5
down 1
forward 8
down 3
forward 7
up 1
down 3
forward 2
up 8
down 2
forward 4
forward 4
forward 4
down 5
up 6
down 3
forward 5
down 4
up 5
forward 1
forward 6
up 1
down 3
forward 2
forward 9
down 7
down 4
forward 5
up 3
up 6
up 1
forward 4
forward 1
forward 1
down 7
up 4
down 3
down 8
down 3
forward 8
forward 3
down 6
down 9
forward 3
forward 9
forward 7
down 8
down 6
down 4
forward 2
up 4
forward 8
down 1
forward 9
forward 1
down 9
forward 2
down 7
down 2
up 7
down 1
up 8
forward 8
down 7
forward 1
down 1
forward 3
forward 1
up 2
down 7
down 5
forward 5
down 8
forward 4
down 1
up 2
up 8
down 8
down 1
down 5
up 3
forward 3
forward 5
down 2
up 4
down 2
forward 7
forward 9
up 9
up 7
forward 1
up 4
forward 3
up 5
forward 9
forward 9
forward 6
forward 2
down 7
forward 8
forward 4
forward 7
down 8
down 5
down 6
forward 6
down 4
down 1
down 9
down 1
forward 3
forward 5
down 6
down 7
down 9
down 8
down 4
up 5
forward 7
down 9
forward 6
down 7
forward 5
down 5
forward 1
down 5
down 3
up 9
up 3
forward 2
up 9
forward 6
down 1
down 5
down 9
down 4
up 6
forward 9
down 4
down 9
down 5
down 8
down 5
down 4
up 5
down 8
up 8
forward 5
down 9
forward 2
up 2
down 6
forward 2
forward 4
forward 6
down 6
down 1
forward 8
down 5
down 5
forward 2
down 7
down 5
down 6
down 9
forward 4
up 9
down 3
down 7
forward 3
down 5
up 1
forward 5
up 2
down 2
forward 2
up 3
up 6
forward 2
forward 7
down 8
forward 8
forward 7
forward 6
down 5
down 6
down 6
down 9
up 5
down 3
up 1
up 9
up 5
down 4
down 4
down 8
forward 8
up 5
down 9
forward 1
up 1
forward 2
down 9
forward 5
up 9
forward 7
down 7
down 5
up 1
up 2
down 8
down 7
up 4
forward 9
down 4
up 8
down 5
down 1
forward 9
down 6
up 8
down 6
forward 7
up 6
up 5
forward 2
up 7
forward 7
forward 5
down 1
forward 9
down 8
forward 9
down 3
down 3
forward 9
up 1
down 2
forward 9
down 7
forward 4
forward 3
forward 4
down 5
forward 9
forward 9
down 5
forward 4
down 5
down 2
down 6
forward 5
forward 8
forward 6
up 9
down 9
forward 7
down 6
down 7
down 4
forward 1
forward 3
forward 6
forward 4
forward 3
forward 4
down 1
forward 2
forward 3
forward 9
up 8
forward 6
down 1
up 5
down 1
down 4
down 7
down 5
down 9
down 2
down 9
forward 2
down 2
up 5
forward 2
forward 3
forward 5
up 8
up 1
down 9
forward 2
down 4
down 9
down 6
down 5
down 8
forward 3
forward 8
forward 7
up 3
up 5
down 9
down 5
up 6
forward 4
forward 4
forward 4
down 9
down 2
down 7
down 1
down 2
down 4
forward 7
down 9
forward 4
forward 5
up 5
forward 4
forward 9
forward 1
forward 5
down 3
forward 1
forward 5
up 9
down 7
forward 7
forward 6
down 2
down 3
forward 9
down 1
forward 4
forward 9
up 7
forward 7
down 5
forward 9
forward 2
up 3
down 3
down 7
down 5
up 7
up 9
up 7
forward 3
forward 3
forward 8
up 9
forward 8
forward 9
forward 4
down 2
forward 7
down 6
up 3
up 9
forward 8
forward 2
down 9
down 7
forward 1
up 4
up 7
forward 2
up 4
forward 4
up 1
forward 3
down 7
forward 5
down 4
forward 2
forward 7
up 4
down 1
down 6
forward 1
forward 9
up 6
forward 7
forward 7
down 8
forward 7
down 8
down 9
up 3
forward 3
forward 3
down 8
up 2
down 2
down 4
up 3
down 3
forward 7
down 4
up 8
down 9
down 9
up 7
down 1
forward 2
up 1
down 3
up 9
down 6
up 2
forward 6
up 8
up 1
down 6
down 1
up 6
up 4
up 2
forward 6
down 6
down 1
forward 7
up 9
up 1
forward 4
forward 5
up 6
forward 9
down 1
down 9
down 3
down 7
forward 7
down 1
down 4
forward 6
down 5
up 4
forward 9
up 5
down 1
down 2
down 2
up 4
forward 1
forward 3
down 7
forward 4
down 4
down 8
down 5
forward 3
up 4
forward 5
down 2
down 4
down 4
down 1
forward 2
forward 1
forward 8
forward 4
up 4
down 9
up 6
forward 9
up 5
down 5
forward 3
up 1
forward 7
down 4
forward 7
down 9
up 8
down 5
forward 1
down 5
down 8
forward 3
up 6
forward 3
up 7
forward 6
forward 9
up 1
down 3
down 9
up 4
up 6
forward 5
down 6
down 3
down 4
up 1
forward 5
down 5
down 2
forward 6
down 8
down 3
up 8
forward 5
forward 6
down 6
down 6
down 6
forward 7
up 4
forward 7
up 4
down 2
forward 4
forward 2
down 6
up 1
down 1
down 4
up 8
down 6
forward 3
forward 6
down 6
forward 5
down 4
up 2
up 3
down 3
up 1
forward 2
up 1
forward 4
up 5
up 2
down 7
forward 3
up 2
forward 5
down 1
down 3
down 2
forward 5
down 1
up 5
forward 4
down 7
up 8
up 3
down 7
down 7
forward 9
forward 1
up 6
down 4
down 7
forward 1
down 4
forward 9
up 1
forward 3
down 1
up 3
down 6
down 8
down 6
forward 6
forward 6
up 2
down 8
forward 5
"""
