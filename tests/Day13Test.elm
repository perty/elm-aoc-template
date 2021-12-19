module Day13Test exposing (suite, testInput, testInputParsed)

import Day13
import Expect exposing (Expectation)
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
                \_ -> Day13.solution1 Day13.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day13.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day13.solution2 Day13.puzzleInput |> Expect.equal -1
            ]
        ]


foldInput =
    """
0,3
0,6
0,9
1,4
3,0
4,3
4,8
4,10
10,1
10,6   
10,8   
10,9
11,4
12,6
12,10
13,0
14,0
14,2

fold along y=7
    """


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
    , folds = [ Day13.Up 7, Day13.Left 5 ]
    }
