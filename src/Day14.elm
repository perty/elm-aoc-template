module Day14 exposing (..)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, andThen, int, oneOf, spaces, succeed, symbol)
import Parser.Extras
import Set exposing (Set)


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


parse : String -> Int
parse string =
    32


solve1 : Int -> Int
solve1 _ =
    42


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
