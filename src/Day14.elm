module Day14 exposing (Input, ParsedRule(..), Rules, count, insertMany, main, matchPair, parse, parseChar, parseRule, parsedRuleToTuple, parser, puzzleInput, solution1, solution2, solve1, solve2, stringToChar, toDict)

import Dict exposing (Dict)
import Html exposing (Html)
import List.Extra as List
import Parser exposing ((|.), (|=), Parser, andThen, chompWhile, getChompedString, int, spaces, succeed, symbol)
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
            insertMany input.rules 10 (String.toList input.template)

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


insertMany : Rules -> Int -> List Char -> List Char
insertMany rules int template =
    if int <= 0 then
        template

    else
        insert2 rules template |> insertMany rules (int - 1)


matchPair : Rules -> String -> Maybe Char
matchPair rules string =
    Dict.get string rules


insert2 : Rules -> List Char -> List Char
insert2 rules chars =
    case chars of
        first :: second :: tail ->
            case matchPair rules (String.fromList [ first, second ]) of
                Just char ->
                    first :: char :: insert2 rules (second :: tail)

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


solve2 : Input -> Int
solve2 _ =
    4711


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
