module Day14 exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, andThen, int, oneOf, spaces, succeed, symbol)
import Parser.Extras
import Set exposing (Set)


solution1 : String -> Int
solution1 input =
    5


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2


parse : String -> Int
parse string =
    32


solve1 : String -> List ( Int, Char )
solve1 template =
    let
        inserted =
            insert 0 template
    in
    count (String.toList inserted) Dict.empty


type alias Rule =
    Dict String Char


rules =
    Dict.fromList
        [ ( "CH", 'B' )
        , ( "HH", 'N' )
        , ( "CB", 'H' )
        , ( "NH", 'C' )
        , ( "HB", 'C' )
        , ( "HC", 'B' )
        , ( "HN", 'C' )
        , ( "NN", 'C' )
        , ( "BH", 'H' )
        , ( "NC", 'B' )
        , ( "NB", 'B' )
        , ( "BN", 'B' )
        , ( "BB", 'N' )
        , ( "BC", 'B' )
        , ( "CC", 'N' )
        , ( "CN", 'C' )
        ]


matchPair : String -> Maybe Char
matchPair string =
    Dict.get string rules


getPair : Int -> String -> String
getPair int string =
    String.slice int (int + 2) string


insert : Int -> String -> String
insert pos template =
    case getPair pos template |> matchPair of
        Just char ->
            String.slice pos (pos + 1) template
                ++ String.fromChar char
                ++ insert (pos + 1) template

        Nothing ->
            String.slice pos (pos + 1) template


count : List Char -> Dict Char Int -> List ( Int, Char )
count chars dict =
    case chars of
        [] ->
            Dict.toList dict |> List.map (\( c, n ) -> ( n, c )) |> List.sort

        head :: tail ->
            count tail (Dict.insert head (1 + (Dict.get head dict |> Maybe.withDefault 0)) dict)


solve2 : Int -> Int
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
