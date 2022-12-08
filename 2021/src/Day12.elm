module Day12 exposing (Cave(..), CaveConnection(..), CaveGraph, caveToString, checkLength, connectCaves, main, parse, parseBig, parseCaveConnection, parseNode, parseSmall, pathsFromCave, puzzleInput, solution1, solution2, solve1, solve2, toGraph)

import Dict exposing (Dict)
import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, andThen, chompWhile, getChompedString, oneOf, problem, succeed, symbol)
import Set


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


type alias CaveGraph =
    Dict String (List Cave)


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


toGraph : List CaveConnection -> CaveGraph
toGraph caveConnections =
    List.foldl connectCaves Dict.empty caveConnections


connectCaves : CaveConnection -> CaveGraph -> CaveGraph
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
    case caveA of
        Start ->
            Dict.insert keyA (caveB :: currentA) dict

        End ->
            Dict.insert keyB (caveA :: currentB) dict

        _ ->
            case caveB of
                Start ->
                    Dict.insert keyB (caveA :: currentB) dict

                End ->
                    Dict.insert keyA (caveB :: currentA) dict

                _ ->
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
solve1 connections =
    let
        smallCaveRule : Cave -> List Cave -> Bool
        smallCaveRule head v =
            List.member head v
    in
    pathsFromCave smallCaveRule [] [ Start ] (toGraph connections) |> List.length


pathsFromCave : (Cave -> List Cave -> Bool) -> List Cave -> List Cave -> CaveGraph -> List (List Cave)
pathsFromCave smallCaveRule visited caves caveGraph =
    case caves of
        [] ->
            []

        head :: tail ->
            case head of
                End ->
                    let
                        breadth =
                            pathsFromCave smallCaveRule visited tail caveGraph

                        success =
                            List.append [ End ] visited
                    in
                    List.append [ success ] breadth

                Start ->
                    let
                        children =
                            Dict.get "start" caveGraph |> Maybe.withDefault []
                    in
                    pathsFromCave smallCaveRule [ Start ] children caveGraph

                Big name ->
                    let
                        breadth =
                            pathsFromCave smallCaveRule visited tail caveGraph

                        children =
                            Dict.get name caveGraph |> Maybe.withDefault []

                        depth =
                            pathsFromCave smallCaveRule (head :: visited) children caveGraph
                    in
                    List.append depth breadth

                Small name ->
                    let
                        breadth =
                            pathsFromCave smallCaveRule visited tail caveGraph

                        children =
                            Dict.get name caveGraph |> Maybe.withDefault []
                    in
                    if smallCaveRule head visited then
                        breadth

                    else
                        let
                            depth =
                                pathsFromCave smallCaveRule (head :: visited) children caveGraph
                        in
                        List.append depth breadth


solve2 : List CaveConnection -> Int
solve2 connections =
    let
        smallCaveRule : Cave -> List Cave -> Bool
        smallCaveRule head visited =
            let
                isSmall c =
                    case c of
                        Small name ->
                            Just name

                        _ ->
                            Nothing

                smallCaves =
                    List.filterMap (\c -> isSmall c) (head :: visited)

                uniqueSmalls =
                    Set.fromList smallCaves |> Set.size
            in
            List.length smallCaves - uniqueSmalls > 1
    in
    pathsFromCave smallCaveRule [] [ Start ] (toGraph connections) |> List.length


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
