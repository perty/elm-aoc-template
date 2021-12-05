module Day4Test exposing (suite, testInput, testInputParsed)

import Day3
import Day4
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day4"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day4.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day4.solution1 testInput |> Expect.equal 198
            , test "From puzzle input" <|
                \_ -> Day4.solution1 Day4.puzzleInput |> Expect.equal 2498354
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day4.solution2 testInput |> Expect.equal 230
            , test "From puzzle input" <|
                \_ -> Day4.solution2 Day4.puzzleInput |> Expect.equal 3277956
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
