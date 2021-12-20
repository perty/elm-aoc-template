module Day14Test exposing (suite, testInput, testInputParsed)

import Day14
import Dict
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day14"
        [ describe "Problem 1"
            [ test "An insert" <|
                \_ -> Day14.insert 0 "NNCB" |> Expect.equal "NCNBCHB"
            , test "More inserts" <|
                \_ ->
                    Day14.insert 0 "NNCB"
                        |> Day14.insert 0
                        |> Day14.insert 0
                        |> Day14.insert 0
                        |> Expect.equal "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
            , test "Count" <|
                \_ ->
                    Day14.count (String.toList "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB") Dict.empty
                        |> Expect.equal []
            , only <|
                test "Solve 1" <|
                    \_ -> Day14.solve1 "NNCB" |> Expect.equal []
            , test "Parser" <|
                \_ -> Day14.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day14.solution1 testInput |> Expect.equal 1588
            , test "From puzzle input" <|
                \_ -> Day14.solution1 Day14.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day14.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day14.solution2 Day14.puzzleInput |> Expect.equal -1
            ]
        ]


testInput =
    """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
    """


testInputParsed =
    -13
