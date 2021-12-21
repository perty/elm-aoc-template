module Day14 exposing (Input, ParsedRule(..), Rules, count, initPolymers, main, matchPair, nextStep, parse, parseChar, parseRule, parsedRuleToTuple, parser, puzzleInput, solution1, solution2, solve1, solve2, stringToChar, toDict)

import Dict exposing (Dict)
import Html exposing (Html)
import List.Extra as List
import Parser exposing ((|.), (|=), Parser, andThen, chompWhile, getChompedString, spaces, succeed, symbol)
import Parser.Extras


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


type alias Rules =
    Dict String Char


type alias Input =
    { template : String
    , rules : Rules
    }


parse : String -> Input
parse string =
    case Parser.run parser string of
        Ok result ->
            result

        Err error ->
            let
                _ =
                    Debug.log "Parser error" error
            in
            Debug.todo "parse failed"


parser : Parser Input
parser =
    succeed Input
        |. spaces
        |= getChompedString (chompWhile Char.isAlpha)
        |. spaces
        |= (Parser.Extras.many parseRule |> andThen toDict)


toDict : List ( String, Char ) -> Parser (Dict String Char)
toDict list =
    succeed (Dict.fromList list)


type ParsedRule
    = ParsedRule String Char


parseRule : Parser ( String, Char )
parseRule =
    (succeed ParsedRule
        |= getChompedString (chompWhile Char.isAlpha)
        |. spaces
        |. symbol "->"
        |. spaces
        |= parseChar
    )
        |> andThen parsedRuleToTuple


parsedRuleToTuple : ParsedRule -> Parser ( String, Char )
parsedRuleToTuple (ParsedRule s c) =
    succeed ( s, c )


parseChar : Parser Char
parseChar =
    getChompedString (chompWhile Char.isAlpha)
        |> andThen stringToChar


stringToChar : String -> Parser Char
stringToChar string =
    succeed
        (string
            |> String.toList
            |> List.head
            |> Maybe.withDefault '?'
        )


solve1 : Input -> Int
solve1 input =
    let
        inserted =
            List.foldl (\_ acc -> insert input.rules acc) (String.toList input.template) (List.range 1 10)

        countResult =
            count inserted Dict.empty

        smallest =
            List.head countResult
                |> Maybe.withDefault ( 0, '?' )
                |> Tuple.first

        largest =
            List.last countResult
                |> Maybe.withDefault ( 0, '?' )
                |> Tuple.first
    in
    largest - smallest


matchPair : Rules -> String -> Maybe Char
matchPair rules string =
    Dict.get string rules


insert : Rules -> List Char -> List Char
insert rules chars =
    case chars of
        first :: second :: tail ->
            case matchPair rules (String.fromList [ first, second ]) of
                Just char ->
                    first :: char :: insert rules (second :: tail)

                Nothing ->
                    [ first, second ]

        [ single ] ->
            [ single ]

        [] ->
            []


count : List Char -> Dict Char Int -> List ( Int, Char )
count chars dict =
    case chars of
        [] ->
            Dict.toList dict |> List.map (\( c, n ) -> ( n, c )) |> List.sort

        head :: tail ->
            count tail (Dict.insert head (1 + (Dict.get head dict |> Maybe.withDefault 0)) dict)


type alias PolymerPairs =
    Dict ( Char, Char ) Int


initPolymers : List Char -> PolymerPairs -> PolymerPairs
initPolymers chars pairs =
    case chars of
        [] ->
            pairs

        [ _ ] ->
            pairs

        head :: second :: tail ->
            let
                now =
                    Dict.get ( head, second ) pairs |> Maybe.withDefault 0
            in
            initPolymers (second :: tail) (Dict.insert ( head, second ) (1 + now) pairs)


nextStep : Rules -> PolymerPairs -> PolymerPairs
nextStep rules polymerPairs =
    let
        _ =
            Debug.log "polys " polymerPairs

        keys =
            Dict.keys polymerPairs

        insertPair n pair dict =
            Dict.insert pair (n + (Dict.get pair dict |> Maybe.withDefault 0)) dict

        step ( c1, c2 ) dict =
            let
                cPrim =
                    matchPair rules (String.fromList [ c1, c2 ]) |> Maybe.withDefault '?'

                pairs =
                    Dict.get ( c1, c2 ) polymerPairs |> Maybe.withDefault 0
            in
            insertPair pairs ( c1, cPrim ) dict |> insertPair pairs ( cPrim, c2 )
    in
    List.foldl (\k dict -> step k dict) Dict.empty keys


solve2 : Input -> Int
solve2 input =
    let
        inserted =
            List.foldl (\_ acc -> nextStep input.rules acc)
                (initPolymers (String.toList input.template) Dict.empty)
                (List.range 1 40)

        toElements : Dict ( Char, Char ) Int -> Dict Char Int
        toElements polymerPairs =
            let
                _ =
                    Debug.log "result" polymerPairs
            in
            Dict.foldl
                (\( c1, c2 ) v acc ->
                    acc
                        |> Dict.insert c1 (v + (Dict.get c1 acc |> Maybe.withDefault 0))
                        |> Dict.insert c2 (v + (Dict.get c2 acc |> Maybe.withDefault 0))
                )
                Dict.empty
                polymerPairs

        countElements d =
            let
                _ =
                    Debug.log "elements" d
            in
            Dict.toList d
                |> List.map (\( c, n ) -> ( n, c ))

        countResult =
            toElements inserted |> countElements |> List.sort

        smallest =
            List.head countResult
                |> Maybe.withDefault ( -1, '?' )
                |> Tuple.first

        largest =
            List.last countResult
                |> Maybe.withDefault ( -1, '?' )
                |> Tuple.first
    in
    largest - smallest


main : Html Never
main =
    Html.div []
        []


puzzleInput : String
puzzleInput =
    """
ONSVVHNCFVBHKVPCHCPV

VO -> C
VV -> S
HK -> H
FC -> C
VB -> V
NO -> H
BN -> B
FP -> K
CS -> C
HC -> S
FS -> K
KH -> V
CH -> H
BP -> K
OF -> K
SS -> F
SP -> C
PN -> O
CK -> K
KS -> H
HO -> K
FV -> F
SN -> P
HN -> O
KK -> H
KP -> O
CN -> N
BO -> C
CC -> H
PB -> F
PV -> K
BV -> K
PP -> H
KB -> F
NC -> F
PC -> V
FN -> N
NH -> B
CF -> V
PO -> F
KC -> S
VP -> P
HH -> N
OB -> O
KN -> O
PS -> N
SF -> V
VK -> F
CO -> N
KF -> B
VC -> C
SH -> S
HV -> V
FK -> O
NV -> N
SC -> O
BK -> F
BB -> K
HF -> K
OC -> O
KO -> V
OS -> P
FF -> O
PH -> F
FB -> O
NN -> C
NK -> C
HP -> B
PF -> H
PK -> C
NP -> O
NS -> V
CV -> O
VH -> C
OP -> N
SO -> O
SK -> H
SV -> O
NF -> H
BS -> K
BH -> O
VN -> S
HB -> O
OH -> K
CB -> B
BC -> S
OV -> F
BF -> P
OO -> F
HS -> H
ON -> P
NB -> F
CP -> S
SB -> V
VF -> C
OK -> O
FH -> H
KV -> S
FO -> C
VS -> B
"""
