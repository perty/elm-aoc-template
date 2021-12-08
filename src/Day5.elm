module Day5 exposing (EndPoint, Plan, endPointParser, equation, main, parse, planParser, puzzleInput, solution1, solution2, solve1, solve2)

import Dict exposing (Dict)
import Html exposing (Html)
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

        markedPoints =
            List.foldl addPointsToDict Dict.Extra. empty straightLines
    in
    42


type alias P =
    Dict Int (Dict Int Int)


addPointsToDict : VentLine ->(Dict (Int, Int) Int) -> Dict Int (Dict Int Int)
addPointsToDict ventLine acc =
    let
        points =
            pointsOnLine ventLine

        addToDict x y = Dict.get x acc |> Dict.get y |> Maybe.withDefault 0
    in
    List.foldl (\p a -> Dict.insert p.x (Dict.insert p.y 0)) acc points


pointsOnLine : VentLine -> List { x : Int, y : Int }
pointsOnLine ventLine =
    if ventLine.x1 == ventLine.x2 then
        List.range ventLine.y1 ventLine.y2
            |> List.map (\n -> { x = ventLine.x1, y = n })

    else
        List.range ventLine.x1 ventLine.x2
            |> List.map (\n -> { x = n, y = ventLine.y2 })


solve2 : Vents -> Int
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
