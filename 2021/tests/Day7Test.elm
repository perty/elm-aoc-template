module Day7Test exposing (..)

import Day7
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day7"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day7.parse testInput |> Expect.equal testInputAsInts
            , test "As given" <|
                \_ -> Day7.solution1 testInput |> Expect.equal 37
            , test "From puzzle input" <|
                \_ -> Day7.solution1 Day7.puzzleInput |> Expect.equal 352997
            ]
        , describe "Problem 2"
            [ test "Fuel cost 2" <|
                \_ -> Day7.fuelCost2 5 10 |> Expect.equal (1 + 2 + 3 + 4 + 5)
            , test "As given" <|
                \_ -> Day7.solution2 testInput |> Expect.equal 168
            , test "From puzzle input" <|
                \_ -> Day7.solution2 Day7.puzzleInput |> Expect.equal 101571302
            ]
        ]


testInput =
    """
16,1,2,0,4,2,7,1,2,14
    """


testInputAsInts =
    [ 16, 1, 2, 0, 4, 2, 7, 1, 2, 14 ]
