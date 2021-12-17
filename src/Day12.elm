module Day12 exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, andThen, chompWhile, getChompedString, oneOf, problem, succeed, symbol)


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
    = CaveConnection Cave Cave


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
        |> List.map String.trim
        |> List.map (\line -> Parser.run parseCaveConnection line)
        |> List.filterMap (\r -> filterOk r)


parseCaveConnection : Parser CaveConnection
parseCaveConnection =
    succeed CaveConnection
        |= parseNode
        |. symbol "-"
        |= parseNode


parseNode : Parser Cave
parseNode =
    oneOf
        [ succeed Start
            |. symbol "start"
        , succeed End
            |. symbol "end"
        , succeed Small
            |= parseSmall
        , succeed Big
            |= parseBig
        ]


parseSmall : Parser String
parseSmall =
    (getChompedString <|
        succeed ()
            |. chompWhile (\c -> Char.isLower c)
    )
        |> andThen checkLength


parseBig : Parser String
parseBig =
    (getChompedString <|
        succeed ()
            |. chompWhile (\c -> Char.isUpper c)
    )
        |> andThen checkLength


checkLength : String -> Parser String
checkLength code =
    if String.length code > 0 then
        succeed code

    else
        problem "not a string"


toGraph : List CaveConnection -> Dict String (List Cave)
toGraph caveConnections =
    let
        _ =
            Debug.log "connections" caveConnections
    in
    List.foldl connectCaves Dict.empty caveConnections


connectCaves : CaveConnection -> Dict String (List Cave) -> Dict String (List Cave)
connectCaves caveConnection dict =
    let
        (CaveConnection caveA caveB) =
            caveConnection

        keyA =
            caveToString caveA

        keyB =
            caveToString caveB

        currentA =
            Dict.get keyA dict |> Maybe.withDefault []

        currentB =
            Dict.get keyB dict |> Maybe.withDefault []
    in
    Dict.insert keyA (caveB :: currentA) dict
        |> Dict.insert keyB (caveA :: currentB)


caveToString : Cave -> String
caveToString cave =
    case cave of
        Start ->
            "start"

        End ->
            "end"

        Big string ->
            string

        Small string ->
            string


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
