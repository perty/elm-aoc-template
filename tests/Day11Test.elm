module Day11Test exposing (..)

import Array
import Day11 exposing (Dumbo(..))
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day11"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day11.parse testInput |> Expect.equal parsedTestInput
            , test "Flash element" <|
                \_ -> Day11.flashElement 1 1 incrementByOne |> Expect.equal flashedCell11
            , test "Flash  matrix once" <|
                \_ -> Day11.flashMatrix 0 (Day11.incrementByOne flashInput) |> Expect.equal flashedMatrix
            , test "Flash until stable" <|
                \_ ->
                    Day11.flashUntilStable (Day11.incrementByOne flashInput)
                        |> Expect.equal untilStable
            , test "One step" <|
                \_ ->
                    Day11.nextStep flashInput
                        |> Expect.equal oneStep
            , test "As given" <|
                \_ -> Day11.solution1 testInput |> Expect.equal 1656
            ]
        , describe "Problem 2"
            [ test "As given, sliding window of 3" <|
                \_ -> Day11.solution2 testInput |> Expect.equal -1
            ]
        ]


testInput =
    """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
    """


parsedTestInput =
    Array.fromList
        [ Array.fromList [ 5, 4, 8, 3, 1, 4, 3, 2, 2, 3 ]
        , Array.fromList [ 2, 7, 4, 5, 8, 5, 4, 7, 1, 1 ]
        , Array.fromList [ 5, 2, 6, 4, 5, 5, 6, 1, 7, 3 ]
        , Array.fromList [ 6, 1, 4, 1, 3, 3, 6, 1, 4, 6 ]
        , Array.fromList [ 6, 3, 5, 7, 3, 8, 5, 4, 7, 8 ]
        , Array.fromList [ 4, 1, 6, 7, 5, 2, 4, 6, 4, 5 ]
        , Array.fromList [ 2, 1, 7, 6, 8, 4, 1, 7, 2, 1 ]
        , Array.fromList [ 6, 8, 8, 2, 8, 8, 1, 1, 3, 4 ]
        , Array.fromList [ 4, 8, 4, 6, 8, 4, 8, 5, 5, 4 ]
        , Array.fromList [ 5, 2, 8, 3, 7, 5, 1, 5, 2, 6 ]
        ]


flashInput =
    Array.fromList
        [ Array.fromList [ Value 1, Value 1, Value 1, Value 1, Value 1 ]
        , Array.fromList [ Value 1, Value 9, Value 9, Value 9, Value 1 ]
        , Array.fromList [ Value 1, Value 9, Value 1, Value 9, Value 1 ]
        , Array.fromList [ Value 1, Value 9, Value 9, Value 9, Value 1 ]
        , Array.fromList [ Value 1, Value 1, Value 1, Value 1, Value 1 ]
        ]


incrementByOne =
    Array.fromList
        [ Array.fromList [ Value 2, Value 2, Value 2, Value 2, Value 2 ]
        , Array.fromList [ Value 2, Value 10, Value 10, Value 10, Value 2 ]
        , Array.fromList [ Value 2, Value 10, Value 2, Value 10, Value 2 ]
        , Array.fromList [ Value 2, Value 10, Value 10, Value 10, Value 2 ]
        , Array.fromList [ Value 2, Value 2, Value 2, Value 2, Value 2 ]
        ]


flashedCell11 =
    Array.fromList
        [ Array.fromList [ Value 3, Value 3, Value 3, Value 2, Value 2 ]
        , Array.fromList [ Value 3, Flashed, Value 11, Value 10, Value 2 ]
        , Array.fromList [ Value 3, Value 11, Value 3, Value 10, Value 2 ]
        , Array.fromList [ Value 2, Value 10, Value 10, Value 10, Value 2 ]
        , Array.fromList [ Value 2, Value 2, Value 2, Value 2, Value 2 ]
        ]


flashedMatrix =
    Array.fromList
        [ Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        , Array.fromList [ Value 4, Flashed, Flashed, Flashed, Value 4 ]
        , Array.fromList [ Value 5, Flashed, Value 10, Flashed, Value 5 ]
        , Array.fromList [ Value 4, Flashed, Flashed, Flashed, Value 4 ]
        , Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        ]


untilStable =
    Array.fromList
        [ Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        , Array.fromList [ Value 4, Flashed, Flashed, Flashed, Value 4 ]
        , Array.fromList [ Value 5, Flashed, Flashed, Flashed, Value 5 ]
        , Array.fromList [ Value 4, Flashed, Flashed, Flashed, Value 4 ]
        , Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        ]


oneStep =
    Array.fromList
        [ Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        , Array.fromList [ Value 4, Value 0, Value 0, Value 0, Value 4 ]
        , Array.fromList [ Value 5, Value 0, Value 0, Value 0, Value 5 ]
        , Array.fromList [ Value 4, Value 0, Value 0, Value 0, Value 4 ]
        , Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        ]
