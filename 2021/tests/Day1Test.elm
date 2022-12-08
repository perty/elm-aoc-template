module Day1Test exposing (..)

import Day1
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day1"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day1.parse testInput |> Expect.equal testInputAsInts
            , test "As given" <|
                \_ -> Day1.solution1 testInput |> Expect.equal 7
            ]
        , describe "Problem 2"
            [ test "As given, sliding window of 3" <|
                \_ -> Day1.solution2 testInput |> Expect.equal 5
            ]
        ]


testInput =
    """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """


testInputAsInts =
    [ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 ]
