module Day4Test exposing (suite)

import Day4
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day4"
        [ describe "Problem 1"
            [ test "As given" <|
                \_ -> Day4.solution1 testInput1 |> Expect.equal "2"
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day4.solution2 testInput1 |> Expect.equal "4"
            ]
        ]


testInput1 =
    """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
    """
