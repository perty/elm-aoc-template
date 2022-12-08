module Day12Test exposing (parsedTestInput, smallExample10Paths, smallGraph, suite, testInput)

import Day12 exposing (Cave(..), CaveConnection(..))
import Dict
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day12"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day12.parse testInput |> Expect.equal parsedTestInput
            , test "Build graph" <|
                \_ ->
                    Day12.parse smallExample10Paths
                        |> Day12.toGraph
                        |> Expect.equal smallGraph
            , test "Follow graph" <|
                \_ ->
                    let
                        smallCaveRule : Cave -> List Cave -> Bool
                        smallCaveRule head v =
                            List.member head v
                    in
                    Day12.pathsFromCave smallCaveRule [] [ Start ] smallGraph
                        |> Expect.equal follow
            , test "As given" <|
                \_ -> Day12.solution1 testInput |> Expect.equal 226
            , test "From puzzle input" <|
                \_ -> Day12.solution1 Day12.puzzleInput |> Expect.equal 3369
            ]
        , describe "Problem 2"
            [ test "Small example" <|
                \_ -> Day12.solution2 smallExample10Paths |> Expect.equal 36
            , test "As given" <|
                \_ -> Day12.solution2 testInput |> Expect.equal 3509
            , test "From puzzle input" <|
                \_ -> Day12.solution2 Day12.puzzleInput |> Expect.equal 85883
            ]
        ]


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


smallGraph =
    Dict.fromList
        [ ( "A", [ End, Small "b", Small "c" ] )
        , ( "b", [ End, Small "d", Big "A" ] )
        , ( "c", [ Big "A" ] )
        , ( "d", [ Small "b" ] )
        , ( "start", [ Small "b", Big "A" ] )
        ]


follow =
    [ [ End, Small "b", Start ]
    , [ End, Big "A", Small "b", Start ]
    , [ End, Big "A", Small "c", Big "A", Small "b", Start ]
    , [ End, Big "A", Start ]
    , [ End, Small "b", Big "A", Start ]
    , [ End, Big "A", Small "b", Big "A", Start ]
    , [ End, Big "A", Small "c", Big "A", Small "b", Big "A", Start ]
    , [ End, Big "A", Small "c", Big "A", Start ]
    , [ End, Small "b", Big "A", Small "c", Big "A", Start ]
    , [ End, Big "A", Small "b", Big "A", Small "c", Big "A", Start ]
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


parsedTestInput =
    [ CaveConnection (Small "fs") End
    , CaveConnection (Small "he") (Big "DX")
    , CaveConnection (Small "fs") (Small "he")
    , CaveConnection Start (Big "DX")
    , CaveConnection (Small "pj") (Big "DX")
    , CaveConnection End (Small "zg")
    , CaveConnection (Small "zg") (Small "sl")
    , CaveConnection (Small "zg") (Small "pj")
    , CaveConnection (Small "pj") (Small "he")
    , CaveConnection (Big "RW") (Small "he")
    , CaveConnection (Small "fs") (Big "DX")
    , CaveConnection (Small "pj") (Big "RW")
    , CaveConnection (Small "zg") (Big "RW")
    , CaveConnection Start (Small "pj")
    , CaveConnection (Small "he") (Big "WI")
    , CaveConnection (Small "zg") (Small "he")
    , CaveConnection (Small "pj") (Small "fs")
    , CaveConnection Start (Big "RW")
    ]
