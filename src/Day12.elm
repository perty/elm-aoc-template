module Day12 exposing (..)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, chompWhile, getChompedString, succeed, symbol)


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


type Cave
    = Start
    | End
    | Big String
    | Small String


type CaveConnection
    = CaveConnection String String


parse : String -> List CaveConnection
parse string =
    let
        filterOk : Result error a -> Maybe a
        filterOk r =
            case r of
                Ok result ->
                    Just result

                Err _ ->
                    Nothing
    in
    string
        |> String.trim
        |> String.lines
        |> List.map (\line -> Parser.run parseCaveConnection line)
        |> List.filterMap (\r -> filterOk r)


parseCaveConnection : Parser CaveConnection
parseCaveConnection =
    succeed CaveConnection
        |= parseNode
        |. symbol "-"
        |= parseNode


parseNode : Parser String
parseNode =
    getChompedString <|
        succeed ()
            |. chompWhile (\c -> Char.isAlpha c)


solve1 : List CaveConnection -> Int
solve1 _ =
    43


solve2 : List CaveConnection -> Int
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
DA-xn
KD-ut
gx-ll
dj-PW
xn-dj
ll-ut
xn-gx
dg-ak
DA-start
ut-gx
YM-ll
dj-DA
ll-xn
dj-YM
start-PW
dj-start
PW-gx
YM-gx
xn-ak
PW-ak
xn-PW
YM-end
end-ll
ak-end
ak-DA
       """
