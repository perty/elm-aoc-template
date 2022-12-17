module Day3Test exposing (suite)

import Day3
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day3"
        [ describe "Problem 1"
            [ test "As given" <|
                \_ -> Day3.solution1 testInput1 |> Expect.equal "157"
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day3.solution2 testInput1 |> Expect.equal "70"
            ]
        ]


testInput1 =
    """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
    """
