module Day2Test exposing (suite)

import Day2
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day2"
        [ describe "Problem 1"
            [ test "As given" <|
                \_ -> Day2.solution1 testInput1 |> Expect.equal 15
            , test "Made up" <|
                \_ -> Day2.solution1 testInput2 |> Expect.equal 45
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day2.solution2 testInput1 |> Expect.equal 12
            , test "Made up" <|
                \_ -> Day2.solution2 testInput2 |> Expect.equal 45
            ]
        ]


testInput1 =
    """
A Y
B X
C Z
    """



-- Problem 1 rules
-- R/R draw 3+1 = 4
-- R/P win  6+2 = 8
-- R/S lose 0+3 = 3
-- P/R lose 0+1 = 1
-- P/P draw 3+2 = 5
-- P/S win  6+3 = 9
-- S/R win  6+1 = 7
-- S/P lose 0+2 = 2
-- S/S draw 3+3 = 6


testInput2 =
    """
A X
A Y
A Z
B X
B Y
B Z
C X
C Y
C Z
    """



-- Problem 2 rules
-- AX R/LS  0 + 3 = 3
-- AY R/DR  3 + 1 = 4
-- AZ R/WP  6 + 2 = 8
-- BX P/LR  0 + 1 = 1
-- BY P/DP  3 + 2 = 5
-- BZ P/WS  6 + 3 = 9
-- CX S/LP  0 + 2 = 2
-- CY S/DS  3 + 3 = 6
-- CZ S/WR  6 + 1 = 7
