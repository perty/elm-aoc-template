module Day5 exposing (EndPoint, Plan, endPointParser, equation, main, parse, planParser, puzzleInput, solution1, solution2, solve1, solve2)

import Array
import Dict exposing (Dict)
import Html exposing (Html)
import List.Extra as List
import Matrix
import Parser exposing ((|.), (|=), Parser, Trailing(..), int, spaces, succeed, symbol)
import Parser.Extras


type alias Vents =
    List VentLine


type alias VentLine =
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


parse : String -> List VentLine
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


endPointParser : Parser VentLine
endPointParser =
    succeed VentLine
        |. spaces
        |= int
        |. symbol ","
        |= int
        |. symbol " -> "
        |= int
        |. symbol ","
        |= int


solve1 : Vents -> Int
solve1 vents =
    let
        straightLines =
            List.filter (\line -> line.x1 == line.x2 || line.y1 == line.y2) vents

        matrix =
            Matrix.initialize 1000 1000 (\_ _ -> 0)

        markedPoints =
            List.foldl addPointsToPlan matrix straightLines
    in
    Array.foldl Array.foldl


foldl : (a -> b -> b) -> b -> (b -> b) -> Matrix.Matrix a -> b
foldl function acc accJoin matrix =
    matrix |> Array.foldl (\co ao -> accJoin co ao) acc (Array.foldl (\c b -> function c acc))


solve2 : Vents -> Int
solve2 _ =
    4711


addPointsToPlan : VentLine -> Matrix.Matrix Int -> Matrix.Matrix Int
addPointsToPlan ventLine acc =
    let
        points =
            pointsOnLine ventLine

        currentValue m p =
            Matrix.get m p.x p.y |> Maybe.withDefault 0

        increment m p =
            Matrix.set m p.x p.y (currentValue m p + 1)
    in
    List.foldl (\p m -> increment m p) acc points


pointsOnLine : VentLine -> List { x : Int, y : Int }
pointsOnLine ventLine =
    let
        lineEq =
            equation ventLine

        xs =
            List.range (Basics.min ventLine.x1 ventLine.x2) (Basics.max ventLine.x1 ventLine.x2)
    in
    List.map (\x -> { x = x, y = lineEq.k * x + lineEq.m }) xs



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
