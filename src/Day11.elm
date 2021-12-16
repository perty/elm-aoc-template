module Day11 exposing (..)

import Array
import Html exposing (Html)
import Matrix exposing (Matrix)


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


type Dumbo
    = Value Int
    | Flashed


parse : String -> Matrix Dumbo
parse string =
    let
        stringToInts : String -> Array.Array Dumbo
        stringToInts s =
            s
                |> String.toList
                |> Array.fromList
                |> Array.map (String.fromChar >> String.toInt >> Maybe.withDefault -1)
                |> Array.map Value
    in
    string
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.map stringToInts
        |> Array.fromList


solve1 : Matrix Dumbo -> Int
solve1 matrix =
    let
        ( _, result ) =
            List.range 1 100
                |> List.foldl (\_ ( m1, n1 ) -> promote ( m1, n1 )) ( matrix, 0 )
    in
    result


promote : ( Matrix Dumbo, Int ) -> ( Matrix Dumbo, Int )
promote ( matrix, n ) =
    let
        ( m1, n1 ) =
            nextStep matrix
    in
    ( m1, n + n1 )


nextStep : Matrix Dumbo -> ( Matrix Dumbo, Int )
nextStep matrix =
    matrix
        |> incrementByOne
        |> flashUntilStable
        |> resetFlashed


resetFlashed : Matrix Dumbo -> ( Matrix Dumbo, Int )
resetFlashed matrix =
    let
        reset _ _ e =
            case e of
                Flashed ->
                    Value 0

                Value _ ->
                    e

        flashes =
            foldl
                (\e acc ->
                    if e == Flashed then
                        acc + 1

                    else
                        acc
                )
                0
                (+)
                matrix
    in
    ( Matrix.indexedMap reset matrix, flashes )


foldl : (a -> b -> b) -> b -> (b -> b -> b) -> Matrix.Matrix a -> b
foldl function acc accJoin matrix =
    Array.foldl (\ma a -> Array.foldl function acc ma |> accJoin a) acc matrix


incrementByOne : Matrix Dumbo -> Matrix Dumbo
incrementByOne matrix =
    let
        inc e =
            case e of
                Value v ->
                    Value (v + 1)

                Flashed ->
                    Flashed
    in
    Matrix.map inc matrix


flashUntilStable : Matrix Dumbo -> Matrix Dumbo
flashUntilStable matrix =
    let
        flashed =
            flashMatrix 0 matrix
    in
    if flashed == matrix then
        flashed

    else
        flashUntilStable flashed


flashMatrix : Int -> Matrix Dumbo -> Matrix Dumbo
flashMatrix row matrix =
    let
        ( maxRow, _ ) =
            Matrix.size matrix
    in
    if row >= maxRow then
        matrix

    else
        let
            flashed =
                flashRow row matrix
        in
        flashMatrix (row + 1) flashed


flashRow : Int -> Matrix Dumbo -> Matrix Dumbo
flashRow row matrix =
    flashCol row 0 matrix


flashCol : Int -> Int -> Matrix Dumbo -> Matrix Dumbo
flashCol row col matrix =
    let
        ( _, maxCol ) =
            Matrix.size matrix
    in
    if col >= maxCol then
        matrix

    else
        let
            flashed =
                flashElement row col matrix
        in
        flashCol row (col + 1) flashed


flashElement : Int -> Int -> Matrix Dumbo -> Matrix Dumbo
flashElement row col matrix =
    let
        incCell : Int -> Int -> Matrix Dumbo -> Matrix Dumbo
        incCell r c m =
            case Matrix.get matrix r c of
                Just (Value v) ->
                    Matrix.set m r c (Value (v + 1))

                Just Flashed ->
                    m

                Nothing ->
                    m
    in
    case Matrix.get matrix row col of
        Just (Value value) ->
            if value > 9 then
                matrix
                    |> incCell (row + 1) col
                    |> incCell (row - 1) col
                    |> incCell row (col + 1)
                    |> incCell row (col - 1)
                    |> incCell (row - 1) (col - 1)
                    |> incCell (row + 1) (col + 1)
                    |> incCell (row + 1) (col - 1)
                    |> incCell (row - 1) (col + 1)
                    |> (\m -> Matrix.set m row col Flashed)

            else
                matrix

        Just Flashed ->
            matrix

        Nothing ->
            matrix


solve2 : Matrix Dumbo -> Int
solve2 _ =
    4711


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
   7313511551
   3724855867
   2374331571
   4438213437
   6511566287
   6727245532
   3736868662
   2348138263
   2417483121
   8812617112
       """
