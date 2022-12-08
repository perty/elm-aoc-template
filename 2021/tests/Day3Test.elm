module Day3Test exposing (suite, testInput, testInputParsed)

import Day3
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day3"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day3.parse testInput |> Expect.equal testInputParsed
            , describe "Occurrences"
                [ test "Empty" <|
                    \_ -> Day3.occurrences [ 1, 0, 1 ] [] |> Expect.equal [ 1, 0, 1 ]
                , test "Some found already" <|
                    \_ -> Day3.occurrences [ 1, 0, 1 ] [ 5, 9, 7 ] |> Expect.equal [ 6, 9, 8 ]
                ]
            , test "As given" <|
                \_ -> Day3.solution1 testInput |> Expect.equal 198
            , test "From puzzle input" <|
                \_ -> Day3.solution1 Day3.puzzleInput |> Expect.equal 2498354
            ]
        , describe "Problem 2"
            [ test "oxygen" <|
                \_ -> Day3.oxygen testInputParsed 0 |> Expect.equal [ 1, 0, 1, 1, 1 ]
            , test "carbonOxid" <|
                \_ -> Day3.carbonOxid testInputParsed 0 |> Expect.equal [ 0, 1, 0, 1, 0 ]
            , test "As given" <|
                \_ -> Day3.solution2 testInput |> Expect.equal 230
            , test "From puzzle input" <|
                \_ -> Day3.solution2 Day3.puzzleInput |> Expect.equal 3277956
            ]
        ]


testInput =
    """00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010"""


testInputParsed =
    [ [ 0, 0, 1, 0, 0 ]
    , [ 1, 1, 1, 1, 0 ]
    , [ 1, 0, 1, 1, 0 ]
    , [ 1, 0, 1, 1, 1 ]
    , [ 1, 0, 1, 0, 1 ]
    , [ 0, 1, 1, 1, 1 ]
    , [ 0, 0, 1, 1, 1 ]
    , [ 1, 1, 1, 0, 0 ]
    , [ 1, 0, 0, 0, 0 ]
    , [ 1, 1, 0, 0, 1 ]
    , [ 0, 0, 0, 1, 0 ]
    , [ 0, 1, 0, 1, 0 ]
    ]
