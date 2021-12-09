module Day6Test exposing (suite, testInput, testInputParsed)

import Array
import Day6
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day6"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day6.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day6.solution1 testInput |> Expect.equal 5934
            , test "As given using buckets" <|
                \_ -> Day6.buckets 80 testInputBuckets |> Expect.equal 5934
            , test "From puzzle input" <|
                \_ -> Day6.solution1 Day6.puzzleInput |> Expect.equal 363101
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day6.solution2 testInput |> Expect.equal 26984457539
            , test "From puzzle input" <|
                \_ -> Day6.solution2 Day6.puzzleInput |> Expect.equal 1644286074024
            ]
        ]


testInput =
    """
    3,4,3,1,2
    """


testInputParsed =
    [ 3, 4, 3, 1, 2 ]


testInputBuckets =
    Array.fromList [ 0, 1, 1, 2, 1, 0, 0, 0, 0 ]
