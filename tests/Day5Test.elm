module Day5Test exposing (suite)

import Day5
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day5"
        [ describe "Problem 1"
            [ test "As given" <|
                \_ -> Day5.solution1 testInput1 |> Expect.equal "CMZ"
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day5.solution2 testInput1 |> Expect.equal "???"
            ]
        ]


testInput1 =
    """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
    """
