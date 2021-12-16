module Day12Test exposing (..)

import Array
import Day12
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day12"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day12.parse testInput |> Expect.equal parsedTestInput
            , test "As given" <|
                \_ -> Day12.solution1 testInput |> Expect.equal 226
            , test "From puzzle input" <|
                \_ -> Day12.solution1 Day12.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day12.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day12.solution2 Day12.puzzleInput |> Expect.equal -1
            ]
        ]


testInput =
    """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
    """


smallExample10Paths =
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """


parsedTestInput =
    []
