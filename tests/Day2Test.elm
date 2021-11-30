module Day2Test exposing (suite, testInput)

import Day2
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Day2"
        [ test "Checks password according to policy." <|
            \_ -> Day2.solution testInput |> Expect.equal 2
        , test "Check parser" <|
            \_ ->
                Day2.parse "2-9 c: ccccccccc"
                    |> Expect.equal [ Day2.PasswordEntry 2 9 "c" "ccccccccc" ]
        ]


testInput : String
testInput =
    """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
    """
