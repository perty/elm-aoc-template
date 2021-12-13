module Day10Test exposing (..)

import Day10 exposing (Paren(..), Symbol(..))
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day10"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day10.parse parseTest |> Expect.equal parseTestResult
            , only <|
                test "Single line" <|
                    \_ -> Day10.solution1 singleLineTest |> Expect.equal 26397
            , test "As given" <|
                \_ -> Day10.solution1 testInput |> Expect.equal 26397
            , test "From puzzle input" <|
                \_ -> Day10.solution1 Day10.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day10.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day10.solution2 Day10.puzzleInput |> Expect.equal -1
            ]
        ]


testInput =
    """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
    """


parseTest =
    """
    [({(<(())[]>[[{[]{<()<>>
    """


singleLineTest =
    "{([(<{}[<>[]}>{[]{[(<()>"


parseTestResult =
    [ [ Open Square
      , Open Parenthesis
      , Open Braces
      , Open Parenthesis
      , Open Hook
      , Open Parenthesis
      , Open Parenthesis
      , Close Parenthesis
      , Close Parenthesis
      , Open Square
      , Close Square
      , Close Hook
      , Open Square
      , Open Square
      , Open Braces
      , Open Square
      , Close Square
      , Open Braces
      , Open Hook
      , Open Parenthesis
      , Close Parenthesis
      , Open Hook
      , Close Hook
      , Close Hook
      ]
    ]
