module Day14Test exposing (suite, testInput, testInputParsed)

import Day14
import Dict
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day14"
        [ describe "Problem 1"
            [ test "Count" <|
                \_ ->
                    Day14.count (String.toList "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB") Dict.empty
                        |> Expect.equal [ ( 5, 'H' ), ( 10, 'C' ), ( 11, 'N' ), ( 23, 'B' ) ]
            , test "Parser" <|
                \_ -> Day14.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day14.solution1 testInput |> Expect.equal 1588
            , test "From puzzle input" <|
                \_ -> Day14.solution1 Day14.puzzleInput |> Expect.equal 3259
            ]
        , describe "Problem 2"
            [ test "Next step" <|
                \_ ->
                    Day14.nextStep testInputParsed.rules (Day14.initPolymers (String.toList "NNCB") Dict.empty)
                        |> Expect.equal expectedNextStep
            , test "Next step 2" <|
                \_ ->
                    Day14.nextStep testInputParsed.rules (Day14.initPolymers (String.toList "NNCB") Dict.empty)
                        |> Day14.nextStep testInputParsed.rules
                        |> Expect.equal expectedNextStep2
            , test "Next step 3" <|
                \_ ->
                    Day14.nextStep testInputParsed.rules (Day14.initPolymers (String.toList "NNCB") Dict.empty)
                        |> Day14.nextStep testInputParsed.rules
                        |> Day14.nextStep testInputParsed.rules
                        |> Expect.equal expectedNextStep3
            , test "Next step 4" <|
                \_ ->
                    Day14.nextStep testInputParsed.rules (Day14.initPolymers (String.toList "NNCB") Dict.empty)
                        |> Day14.nextStep testInputParsed.rules
                        |> Day14.nextStep testInputParsed.rules
                        |> Day14.nextStep testInputParsed.rules
                        |> Expect.equal expectedNextStep4
            , only <|
                test "As given" <|
                    \_ -> Day14.solution2 testInput |> Expect.equal 2188189693529
            , test "From puzzle input" <|
                \_ -> Day14.solution2 Day14.puzzleInput |> Expect.equal -1
            ]
        ]


expectedNextStep =
    Day14.initPolymers (String.toList "NCNBCHB") Dict.empty


expectedNextStep2 =
    Day14.initPolymers (String.toList "NBCCNBBBCBHCB") Dict.empty


expectedNextStep3 =
    Day14.initPolymers (String.toList "NBBBCNCCNBBNBNBBCHBHHBCHB") Dict.empty


expectedNextStep4 =
    Day14.initPolymers (String.toList "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB") Dict.empty


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


testInputParsed : Day14.Input
testInputParsed =
    { template = "NNCB"
    , rules =
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
    }
