module Day13Test exposing (suite, testInput, testInputParsed)

import Day13 exposing (Fold(..))
import Expect exposing (Expectation)
import Matrix
import Test exposing (..)


suite : Test
suite =
    describe "Day13"
        [ describe "Problem 1"
            [ only <|
                test "Parser" <|
                    \_ -> Day13.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day13.solution1 testInput |> Expect.equal 5
            , test "From puzzle input" <|
                \_ -> Day13.solution1 Day13.puzzleInput |> Expect.equal 8060
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day13.solution2 testInput |> Expect.equal 12
            , test "From puzzle input" <|
                \_ -> Day13.solution2 Day13.puzzleInput |> Expect.equal 21577
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
    , folds = [ Up 7, Left 5 ]
    }
