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
            , describe "Rows bingo"
                [ test "No bingo" <|
                    \_ ->
                        Day4.rowsBingo [ 1, 2, 3, 4, 5 ] [ [ 6, 7, 8, 9, 10 ], [ 11, 12, 13, 14, 15 ] ]
                            |> Expect.equal False
                , test "bingo" <|
                    \_ ->
                        Day4.rowsBingo [ 1, 2, 3, 4, 5 ] [ [ 6, 7, 8, 9, 10 ], [ 2, 1, 3, 4, 5 ] ]
                            |> Expect.equal True
                ]
            , describe "Cols bingo"
                [ test "No bingo" <|
                    \_ ->
                        Day4.colsBingo [ 1, 2, 3, 4, 5 ] [ [ 6, 7, 8, 9, 10 ], [ 11, 12, 13, 14, 15 ] ] 0
                            |> Expect.equal False
                , test "bingo" <|
                    \_ ->
                        Day4.colsBingo [ 1, 2, 3, 4, 5 ] [ [ 6, 2, 8, 9, 10 ], [ 12, 1, 3, 4, 5 ] ] 0
                            |> Expect.equal True
                ]
            , describe "Winner board"
                [ test "Simple" <|
                    \_ -> Day4.winner winner1 0 |> Expect.equal (Just ( board1, [ 1, 2, 3, 4, 5, 6 ] ))
                ]
            , test "As given" <|
                \_ -> Day4.solution1 testInput |> Expect.equal 4512
            , test "From puzzle input" <|
                \_ -> Day4.solution1 Day4.puzzleInput |> Expect.equal 8442
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day4.solution2 testInput |> Expect.equal 1924
            , test "From puzzle input" <|
                \_ -> Day4.solution2 Day4.puzzleInput |> Expect.equal 4590
            ]
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


winner1 : Day4.Bingo
winner1 =
    { numbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
    , boards =
        [ board1
        , board2
        ]
    }


board1 : Day4.Board
board1 =
    [ [ 3, 4, 5, 6 ]
    , [ 12, 34, 0 ]
    ]


board2 : Day4.Board
board2 =
    [ [ 12, 34, 7 ]
    , [ 18, 19, 8 ]
    ]
