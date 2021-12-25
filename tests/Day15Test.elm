module Day15Test exposing (parsedTestInput, suite, testInput)

import Day15
import Expect exposing (Expectation)
import Matrix
import Test exposing (..)


suite : Test
suite =
    describe "Day15"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day15.parse testInput |> Expect.equal parsedTestInput
            , test "As given" <|
                \_ -> Day15.solution1 testInput |> Expect.equal 40
            , test "From puzzle input" <|
                \_ -> Day15.solution1 Day15.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day15.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day15.solution2 Day15.puzzleInput |> Expect.equal -1
            ]
        ]


testInput =
    """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""


parsedTestInput =
    Matrix.empty
