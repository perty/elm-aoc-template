module Day5 exposing (EndPoint, Plan, endPointParser, equation, main, parse, planParser, puzzleInput, solution1, solution2, solve1, solve2)

import Html exposing (Html)
import Parser exposing ((|.), (|=), Parser, Trailing(..), int, spaces, succeed, symbol)
import Parser.Extras


type alias Plan =
    List EndPoint


type alias EndPoint =
    { x1 : Int
    , y1 : Int
    , x2 : Int
    , y2 : Int
    }


solution1 : String -> Int
solution1 input =
    input
        |> parse
        |> solve1


solution2 : String -> Int
solution2 input =
    input
        |> parse
        |> solve2


parse : String -> List EndPoint
parse string =
    case Parser.run planParser string of
        Ok plan ->
            plan

        Err error ->
            let
                _ =
                    Debug.log "Parse error" error
            in
            []


planParser =
    Parser.Extras.many endPointParser


endPointParser : Parser EndPoint
endPointParser =
    succeed EndPoint
        |. spaces
        |= int
        |. symbol ","
        |= int
        |. symbol " -> "
        |= int
        |. symbol ","
        |= int


solve1 : Plan -> Int
solve1 _ =
    42


solve2 : Plan -> Int
solve2 _ =
    4711



{-
   y1 = kx1 + m
   y2 = kx2 + m
   m = y2 - kx2
   k = abs (y1 - y2) / abs(x1 - x2)
-}


equation : { x1 : Int, y1 : Int, x2 : Int, y2 : Int } -> { k : Int, m : Int }
equation p =
    let
        k =
            Basics.abs (p.y1 - p.y2) // Basics.abs (p.x1 - p.x2)
    in
    { k = k, m = p.y2 - k * p.x2 }


main : Html Never
main =
    Html.div []
        [ Html.p []
            [ Html.text (String.fromInt (solution1 puzzleInput))
            ]
        , Html.p [] [ Html.text (String.fromInt (solution2 puzzleInput)) ]
        ]


puzzleInput : String
puzzleInput =
    """
    
    """
