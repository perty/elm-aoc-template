module Day2Test exposing (suite, testInput)

import Day2
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day2"
        [ test "Checks password according to policy 1." <|
            \_ -> Day2.solution1 testInput |> Expect.equal 2
        , test "Checks password according to policy 2." <|
            \_ -> Day2.solution2 testInput |> Expect.equal 1
        , test "Check parser 1" <|
            \_ ->
                Day2.parse "2-9 c: ccccccccc"
                    |> Expect.equal [ Day2.PasswordEntry 2 9 "c" "ccccccccc" ]
        , test "Check parser 2" <|
            \_ ->
                Day2.parse "10-12 q: qqqqbqlpqqfqaq"
                    |> Expect.equal [ Day2.PasswordEntry 10 12 "q" "qqqqbqlpqqfqaq" ]
        , describe "Valid 2"
            [ test "Only one" <|
                \_ ->
                    Day2.validEntry2 { char = "m", first = 5, password = "1234m6", second = 6 }
                        |> Expect.equal True
            , test "No char" <|
                \_ ->
                    Day2.validEntry2 { char = "m", first = 5, password = "123456", second = 6 }
                        |> Expect.equal False
            , test "First and last" <|
                \_ ->
                    Day2.validEntry2 { char = "m", first = 1, password = "m2345m", second = 6 }
                        |> Expect.equal False
            , test "In second position" <|
                \_ ->
                    Day2.validEntry2 { char = "m", first = 1, password = "12345m", second = 6 }
                        |> Expect.equal True
            ]
        ]


testInput : String
testInput =
    """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
10-12 q: qqqqbqlpqqfqaq
    """
