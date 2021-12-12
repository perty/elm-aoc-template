module Day9Test exposing (suite, testInput, testInput4Parse, testInputParsed)

import Array
import Day9
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day9"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day9.parse testInput4Parse |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day9.solution1 testInput |> Expect.equal 15
            , test "From puzzle input" <|
                \_ -> Day9.solution1 Day9.puzzleInput |> Expect.equal 591
            ]
        , describe "Problem 2"
            [ test "Basin size top-right" <|
                \_ -> Day9.basinSize 0 9 parseTestInput |> Expect.equal 9
            , test "Basin size middle" <|
                \_ -> Day9.basinSize 2 2 parseTestInput |> Expect.equal 14
            , test "As given" <|
                \_ -> Day9.solution2 testInput |> Expect.equal 1134
            , test "From puzzle input" <|
                \_ -> Day9.solution2 Day9.puzzleInput |> Expect.equal -1
            ]
        ]


parseTestInput =
    Array.fromList [ Array.fromList [ 2, 1, 9, 9, 9, 4, 3, 2, 1, 0 ], Array.fromList [ 3, 9, 8, 7, 8, 9, 4, 9, 2, 1 ], Array.fromList [ 9, 8, 5, 6, 7, 8, 9, 8, 9, 2 ], Array.fromList [ 8, 7, 6, 7, 8, 9, 6, 7, 8, 9 ], Array.fromList [ 9, 8, 9, 9, 9, 6, 5, 6, 7, 8 ] ]


testInput4Parse =
    """  
2199943210
3987894921
   """


testInput =
    """
2199943210
3987894921
9856789892
8767896789
9899965678
"""


testInputParsed =
    Array.fromList
        [ Array.fromList [ 2, 1, 9, 9, 9, 4, 3, 2, 1, 0 ]
        , Array.fromList [ 3, 9, 8, 7, 8, 9, 4, 9, 2, 1 ]
        ]
