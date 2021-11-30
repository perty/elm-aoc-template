module Day1bTest exposing (suite, testInput)

import Day1b
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    test "Takes three values that sum to 2020 and multiplies them." <|
        \_ -> Day1b.solution2 testInput |> Expect.equal 241861950


testInput : String
testInput =
    """
    1721
    979
    366
    299
    675
    1456
    """
