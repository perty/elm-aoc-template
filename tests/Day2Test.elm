module Day2Test exposing (..)

import Day2 exposing (Command(..))
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Day1"
        [ describe "Problem 1"
            [ test "Parser" <|
                \_ -> Day2.parse testInput |> Expect.equal testInputParsed
            , test "As given" <|
                \_ -> Day2.solution1 testInput |> Expect.equal 150
            ]
        , describe "Problem 2"
            [ test "As given" <|
                \_ -> Day2.solution2 testInput |> Expect.equal -1
            ]
        ]


testInput =
    """
    forward 5
    down 5
forward 8
up 3
down 8
forward 2
    """


testInputParsed =
    [ Forward 5
    , Down 5
    , Forward 8
    , Up 3
    , Down 8
    , Forward 2
    ]
