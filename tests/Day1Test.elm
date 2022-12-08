module Day1Test exposing (suite)

import Day1
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day1"
        [ describe "Problem 1"
            [ test "As given" <|
                \_ -> Day1.solution1 testInput1 |> Expect.equal "24000"
            ]
        ]


testInput1 =
    """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """
