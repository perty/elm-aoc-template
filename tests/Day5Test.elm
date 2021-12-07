module Day5Test exposing (suite, testInput, testInputParsed)

import Day5
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day5"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day5.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day5.solution1 testInput |> Expect.equal 5
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day5.solution2 testInput |> Expect.equal -1
            ]
        ]


testInput =
    """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
    """


testInputParsed =
    [ Day5.EndPoint 0 9 5 9
    , Day5.EndPoint 8 0 0 8
    , Day5.EndPoint 9 4 3 4
    , Day5.EndPoint 2 2 2 1
    , Day5.EndPoint 7 0 7 4
    , Day5.EndPoint 6 4 2 0
    , Day5.EndPoint 0 9 2 9
    , Day5.EndPoint 3 4 1 4
    , Day5.EndPoint 0 0 8 8
    , Day5.EndPoint 5 5 8 2
    ]
