module Day13Test exposing (suite, testInput, testInputParsed)

import Day13
import Expect exposing (Expectation)
import Set
import Test exposing (..)


suite : Test
suite =
    describe "Day13"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day13.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day13.solution1 testInput |> Expect.equal 17
            , test "From puzzle input" <|
                \_ -> Day13.solution1 Day13.puzzleInput |> Expect.equal 712
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day13.solution2 testInput |> Expect.equal setFromGiven
            , test "From puzzle input" <|
                \_ -> Day13.solution2 Day13.puzzleInput |> Expect.equal setPuzzle
            ]
        ]


testInput =
    """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
    """


testInputParsed =
    { points =
        [ ( 6, 10 )
        , ( 0, 14 )
        , ( 9, 10 )
        , ( 0, 3 )
        , ( 10, 4 )
        , ( 4, 11 )
        , ( 6, 0 )
        , ( 6, 12 )
        , ( 4, 1 )
        , ( 0, 13 )
        , ( 10, 12 )
        , ( 3, 4 )
        , ( 3, 0 )
        , ( 8, 4 )
        , ( 1, 10 )
        , ( 2, 14 )
        , ( 8, 10 )
        , ( 9, 0 )
        ]
    , folds = [ Day13.Left 7, Day13.Up 5 ]
    }


setFromGiven =
    Set.fromList
        [ ( 0, 0 )
        , ( 0, 1 )
        , ( 0, 2 )
        , ( 0, 3 )
        , ( 0, 4 )
        , ( 1, 0 )
        , ( 1, 4 )
        , ( 2, 0 )
        , ( 2, 4 )
        , ( 3, 0 )
        , ( 3, 4 )
        , ( 4, 0 )
        , ( 4, 1 )
        , ( 4, 2 )
        , ( 4, 3 )
        , ( 4, 4 )
        ]


setPuzzle =
    Set.fromList
        [ ( 0, 0 )
        , ( 0, 1 )
        , ( 0, 2 )
        , ( 0, 3 )
        , ( 0, 4 )
        , ( 0, 5 )
        , ( 1, 0 )
        , ( 1, 2 )
        , ( 1, 5 )
        , ( 2, 0 )
        , ( 2, 2 )
        , ( 2, 5 )
        , ( 3, 1 )
        , ( 3, 3 )
        , ( 3, 4 )
        , ( 5, 0 )
        , ( 5, 1 )
        , ( 5, 2 )
        , ( 5, 3 )
        , ( 5, 4 )
        , ( 5, 5 )
        , ( 6, 5 )
        , ( 7, 5 )
        , ( 8, 5 )
        , ( 10, 0 )
        , ( 10, 1 )
        , ( 10, 2 )
        , ( 10, 3 )
        , ( 10, 4 )
        , ( 10, 5 )
        , ( 11, 2 )
        , ( 12, 2 )
        , ( 13, 0 )
        , ( 13, 1 )
        , ( 13, 2 )
        , ( 13, 3 )
        , ( 13, 4 )
        , ( 13, 5 )
        , ( 15, 0 )
        , ( 15, 1 )
        , ( 15, 2 )
        , ( 15, 3 )
        , ( 15, 4 )
        , ( 15, 5 )
        , ( 16, 0 )
        , ( 16, 2 )
        , ( 17, 0 )
        , ( 17, 2 )
        , ( 18, 0 )
        , ( 20, 4 )
        , ( 21, 5 )
        , ( 22, 0 )
        , ( 22, 5 )
        , ( 23, 0 )
        , ( 23, 1 )
        , ( 23, 2 )
        , ( 23, 3 )
        , ( 23, 4 )
        , ( 25, 0 )
        , ( 25, 1 )
        , ( 25, 2 )
        , ( 25, 3 )
        , ( 25, 4 )
        , ( 25, 5 )
        , ( 26, 0 )
        , ( 26, 3 )
        , ( 27, 0 )
        , ( 27, 3 )
        , ( 28, 1 )
        , ( 28, 2 )
        , ( 30, 4 )
        , ( 31, 5 )
        , ( 32, 0 )
        , ( 32, 5 )
        , ( 33, 0 )
        , ( 33, 1 )
        , ( 33, 2 )
        , ( 33, 3 )
        , ( 33, 4 )
        , ( 35, 0 )
        , ( 35, 1 )
        , ( 35, 2 )
        , ( 35, 3 )
        , ( 35, 4 )
        , ( 35, 5 )
        , ( 36, 0 )
        , ( 36, 2 )
        , ( 37, 0 )
        , ( 37, 2 )
        , ( 38, 0 )
        ]
