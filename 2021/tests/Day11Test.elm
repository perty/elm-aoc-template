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
            , test "From puzzle input" <|
                \_ -> Day11.solution1 Day11.puzzleInput |> Expect.equal 1655
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day11.solution2 testInput |> Expect.equal 195
            , test "From puzzle input" <|
                \_ -> Day11.solution2 Day11.puzzleInput |> Expect.equal 337
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
        [ Array.fromList [ Value 5, Value 4, Value 8, Value 3, Value 1, Value 4, Value 3, Value 2, Value 2, Value 3 ]
        , Array.fromList [ Value 2, Value 7, Value 4, Value 5, Value 8, Value 5, Value 4, Value 7, Value 1, Value 1 ]
        , Array.fromList [ Value 5, Value 2, Value 6, Value 4, Value 5, Value 5, Value 6, Value 1, Value 7, Value 3 ]
        , Array.fromList [ Value 6, Value 1, Value 4, Value 1, Value 3, Value 3, Value 6, Value 1, Value 4, Value 6 ]
        , Array.fromList [ Value 6, Value 3, Value 5, Value 7, Value 3, Value 8, Value 5, Value 4, Value 7, Value 8 ]
        , Array.fromList [ Value 4, Value 1, Value 6, Value 7, Value 5, Value 2, Value 4, Value 6, Value 4, Value 5 ]
        , Array.fromList [ Value 2, Value 1, Value 7, Value 6, Value 8, Value 4, Value 1, Value 7, Value 2, Value 1 ]
        , Array.fromList [ Value 6, Value 8, Value 8, Value 2, Value 8, Value 8, Value 1, Value 1, Value 3, Value 4 ]
        , Array.fromList [ Value 4, Value 8, Value 4, Value 6, Value 8, Value 4, Value 8, Value 5, Value 5, Value 4 ]
        , Array.fromList [ Value 5, Value 2, Value 8, Value 3, Value 7, Value 5, Value 1, Value 5, Value 2, Value 6 ]
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
    ( Array.fromList
        [ Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        , Array.fromList [ Value 4, Value 0, Value 0, Value 0, Value 4 ]
        , Array.fromList [ Value 5, Value 0, Value 0, Value 0, Value 5 ]
        , Array.fromList [ Value 4, Value 0, Value 0, Value 0, Value 4 ]
        , Array.fromList [ Value 3, Value 4, Value 5, Value 4, Value 3 ]
        ]
    , 9
    )
