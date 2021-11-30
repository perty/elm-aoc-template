module Day1Test exposing (suite, testInput)

import Day1
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    test "Takes three values that sum to 2020 and multiplies them." <|
        \_ -> Day1.solution1 testInput |> Expect.equal 514579


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
