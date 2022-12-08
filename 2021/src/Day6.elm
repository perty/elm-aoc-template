module Day6 exposing
    ( buckets
    , main
    , model
    , parse
    , puzzleInput
    , solution1
    , solution2
    , solve1
    , solve2
    )

import Array exposing (Array)
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
solve2 ints =
    let
        bucketsArray =
            intoBuckets ints (Array.initialize 9 (\_ -> 0))
    in
    buckets 256 bucketsArray


intoBuckets : List Int -> Array Int -> Array Int
intoBuckets ints current =
    case ints of
        [] ->
            current

        head :: tail ->
            let
                bucket =
                    Array.get head current |> Maybe.withDefault 0
            in
            intoBuckets tail (Array.set head (bucket + 1) current)


buckets : Int -> Array Int -> Int
buckets days current =
    if days == 0 then
        Array.foldl (+) 0 current

    else
        let
            zeroBucket =
                Array.get 0 current |> Maybe.withDefault 0

            rotated =
                Array.slice 1 9 current |> Array.push zeroBucket

            mature =
                Array.get 6 rotated |> Maybe.withDefault 0
        in
        buckets (days - 1) (Array.set 6 (mature + zeroBucket) rotated)


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
