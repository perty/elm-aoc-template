module Day4Test exposing (suite, testInput, testInputParsed)

import Day4
import Expect exposing (Expectation)
import Parser
import Test exposing (..)


suite : Test
suite =
    describe "Day4"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day4.parse testInput |> Expect.equal testInputParsed
            , test "Row parser" <|
                \_ ->
                    Parser.run Day4.rowParser "1 2 3 4\n\n5"
                        |> Expect.equal (Ok [ 1, 2, 3, 4 ])
            , test "Board parser" <|
                \_ ->
                    Parser.run Day4.boardsParser "\n1 2 3 4\n5 6 7 8\n8 9 10\n11 12 13\n14 15 16\n\n"
                        |> Expect.equal (Ok [ [ [ 1, 2, 3, 4 ], [ 5, 6, 7, 8 ], [ 8, 9, 10 ], [ 11, 12, 13 ], [ 14, 15, 16 ] ] ])

            {- , test "As given" <|
                   \_ -> Day4.solution1 testInput |> Expect.equal 198
               , test "From puzzle input" <|
                   \_ -> Day4.solution1 Day4.puzzleInput |> Expect.equal 2498354
            -}
            ]

        {- , describe "Problem 2"
           [ test "As given" <|
               \_ -> Day4.solution2 testInput |> Expect.equal 230
           , test "From puzzle input" <|
               \_ -> Day4.solution2 Day4.puzzleInput |> Expect.equal 3277956
           ]
        -}
        ]


testInput =
    """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""


testInputParsed =
    { numbers = [ 7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1 ]
    , boards =
        [ [ [ 22, 13, 17, 11, 0 ]
          , [ 8, 2, 23, 4, 24 ]
          , [ 21, 9, 14, 16, 7 ]
          , [ 6, 10, 3, 18, 5 ]
          , [ 1, 12, 20, 15, 19 ]
          ]
        , [ [ 3, 15, 0, 2, 22 ]
          , [ 9, 18, 13, 17, 5 ]
          , [ 19, 8, 7, 25, 23 ]
          , [ 20, 11, 10, 24, 4 ]
          , [ 14, 21, 16, 12, 6 ]
          ]
        , [ [ 14, 21, 17, 24, 4 ]
          , [ 10, 16, 15, 9, 19 ]
          , [ 18, 8, 23, 26, 20 ]
          , [ 22, 11, 13, 6, 5 ]
          , [ 2, 0, 12, 3, 7 ]
          ]
        ]
    }
