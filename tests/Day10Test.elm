module Day10Test exposing (parseTest, singleLineTest, suite, testInput)

import Day10
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day10"
        [ describe "Problem 1"
            [ test "Chunk Parser" <|
                \_ -> Day10.chunkParse parseTest |> Expect.equal ']'
            , test "Single line" <|
                \_ -> Day10.solution1 singleLineTest |> Expect.equal 1197
            , test "As given" <|
                \_ -> Day10.solution1 testInput |> Expect.equal 26397
            , test "From puzzle input" <|
                \_ -> Day10.solution1 Day10.puzzleInput |> Expect.equal 299793
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
[<><><]
    """


singleLineTest =
    "{([(<{}[<>[]}>{[]{[(<()>"
