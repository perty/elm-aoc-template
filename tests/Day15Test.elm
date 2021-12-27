module Day15Test exposing (parsedTestInput, suite, testInput)

import Array
import Day15 exposing (NodeState(..))
import Expect exposing (Expectation)
import Matrix exposing (Matrix)
import Test exposing (..)


suite : Test
suite =
    describe "Day15"
        [ describe "Problem 1"
            [ test "nextState 1" <|
                \_ ->
                    Day15.nextState miniState
                        |> Expect.equal expectedStep1
            , only <|
                test "nextState 2" <|
                    \_ ->
                        (miniState
                            |> Day15.nextState
                            |> (\s -> Day15.nextState { s | currentNode = Day15.lowest s })
                        )
                            |> Expect.equal expectedStep2
            , only <|
                test "Small example" <|
                    \_ ->
                        Day15.loopUntilGoal (Day15.Point 0 0) (Day15.Point 2 3) miniState
                            |> Expect.equal 14
            , test "Parser" <|
                \_ -> Day15.parse testInput |> Expect.equal parsedTestInput
            , test "As given" <|
                \_ -> Day15.solution1 testInput |> Expect.equal 40
            , test "From puzzle input" <|
                \_ -> Day15.solution1 Day15.puzzleInput |> Expect.equal -1
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day15.solution2 testInput |> Expect.equal -1
            , test "From puzzle input" <|
                \_ -> Day15.solution2 Day15.puzzleInput |> Expect.equal -1
            ]
        ]


miniState : Day15.State
miniState =
    { cave = miniCave
    , currentNode = { point = { row = 0, col = 0 }, value = 0 }
    , unvisited = []
    }


miniCave : Matrix Day15.NodeState
miniCave =
    Array.fromList
        [ Array.fromList [ Day15.Visited 1, Day15.Initial 2, Day15.Initial 6, Day15.Initial 3 ]
        , Array.fromList [ Day15.Initial 1, Day15.Initial 3, Day15.Initial 8, Day15.Initial 1 ]
        , Array.fromList [ Day15.Initial 2, Day15.Initial 1, Day15.Initial 3, Day15.Initial 6 ]
        ]


expectedStep1 =
    { cave =
        Array.fromList
            [ Array.fromList [ Day15.Visited 1, Day15.UnvisitedState { risk = 2, value = 2 }, Day15.Initial 6, Day15.Initial 3 ]
            , Array.fromList [ Day15.UnvisitedState { risk = 1, value = 1 }, Day15.Initial 3, Day15.Initial 8, Day15.Initial 1 ]
            , Array.fromList [ Day15.Initial 2, Day15.Initial 1, Day15.Initial 3, Day15.Initial 6 ]
            ]
    , currentNode = { point = { col = 0, row = 0 }, value = 0 }
    , unvisited =
        [ { point = { col = 1, row = 0 }, value = 2 }
        , { point = { col = 0, row = 1 }, value = 1 }
        ]
    }


expectedStep2 =
    { cave =
        Array.fromList
            [ Array.fromList [ Day15.Visited 1, Day15.UnvisitedState { risk = 2, value = 2 }, Day15.Initial 6, Day15.Initial 3 ]
            , Array.fromList [ Day15.UnvisitedState { risk = 1, value = 1 }, Day15.UnvisitedState { risk = 3, value = 4 }, Day15.Initial 8, Day15.Initial 1 ]
            , Array.fromList [ Day15.UnvisitedState { risk = 2, value = 3 }, Day15.Initial 1, Day15.Initial 3, Day15.Initial 6 ]
            ]
    , currentNode = { point = { col = 0, row = 1 }, value = 1 }
    , unvisited =
        [ { point = { col = 1, row = 1 }, value = 4 }
        , { point = { col = 0, row = 2 }, value = 3 }
        , { point = { col = 1, row = 0 }, value = 2 }
        , { point = { col = 0, row = 1 }, value = 1 }
        ]
    }


testInput =
    """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""


parsedTestInput =
    Matrix.empty
