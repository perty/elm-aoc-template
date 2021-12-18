module Day13Test exposing (suite, testInput, testInputParsed)

import Array
import Day13 exposing (Fold(..), Point(..))
import Expect exposing (Expectation)
import Matrix
import Test exposing (..)


suite : Test
suite =
    describe "Day13"
        [ describe "Problem 1"
            [ test "Fold up" <|
                \_ -> Day13.foldUp 7 foldMatrix |> Expect.equal folded7UpMatrix
            , test "Fold left" <|
                \_ -> Day13.foldLeft 5 folded7UpMatrix |> Expect.equal folded5Left
            , only <|
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


foldMatrix =
    Array.fromList
        [ Array.fromList [ 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1 ]
        , Array.fromList [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 ]
        ]


folded7UpMatrix =
    Array.fromList
        [ Array.fromList [ 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0 ]
        , Array.fromList [ 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1 ]
        , Array.fromList [ 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        ]


folded5Left =
    Array.fromList
        [ Array.fromList [ 1, 1, 1, 1, 1 ]
        , Array.fromList [ 1, 0, 0, 0, 1 ]
        , Array.fromList [ 1, 0, 0, 0, 1 ]
        , Array.fromList [ 1, 0, 0, 0, 1 ]
        , Array.fromList [ 1, 1, 1, 1, 1 ]
        , Array.fromList [ 0, 0, 0, 0, 0 ]
        , Array.fromList [ 0, 0, 0, 0, 0 ]
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
        [ Point 6 10
        , Point 0 14
        , Point 9 10
        , Point 0 3
        , Point 10 4
        , Point 4 11
        , Point 6 0
        , Point 6 12
        , Point 4 1
        , Point 0 13
        , Point 10 12
        , Point 3 4
        , Point 3 0
        , Point 8 4
        , Point 1 10
        , Point 2 14
        , Point 8 10
        , Point 9 0
        ]
    , folds = [ Up 7, Left 5 ]
    }
