module Day10Test exposing (..)

import Day10 exposing (Symbol(..))
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day10"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day10.parse parseTest |> Expect.equal parseTestResult
            , test "As given" <|
                \_ -> Day10.solution1 testInput |> Expect.equal -1
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


parseTestResult =
    [ [ Open "["
      , Open "("
      , Open "{"
      , Open "("
      , Open "<"
      , Open "("
      , Open "("
      , Close ")"
      , Close ")"
      , Open "["
      , Close "]"
      , Close ">"
      , Open "["
      , Open "["
      , Open "{"
      , Open "["
      , Close "]"
      , Open "{"
      , Open "<"
      , Open "("
      , Close ")"
      , Open "<"
      , Close ">"
      , Close ">"
      ]
    ]
