module Day20 exposing (..)

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes
import LineParser
import List
import Matrix exposing (Matrix)
import Matrix.Extra
import Parser exposing ((|.), (|=), Parser)
import Parser.Extra
import Result


size : Int
size =
    10


type alias Tile =
    { id : Int
    , matrix : Matrix Color
    }


type Color
    = White
    | Black


parse : String -> Result String (List Tile)
parse =
    String.trim
        >> String.split "\n\n"
        >> LineParser.parseGeneral "Tile"
            identity
            (Parser.run tileParser
                >> Result.mapError Parser.Extra.deadEndsToString
            )


tileParser : Parser Tile
tileParser =
    Parser.succeed Tile
        |. Parser.symbol "Tile"
        |. Parser.Extra.spaces
        |= Parser.int
        |. Parser.Extra.spaces
        |. Parser.symbol ":"
        |. Parser.Extra.spaces
        |. Parser.symbol "\n"
        |= matrixParser


matrixParser : Parser (Matrix Color)
matrixParser =
    Parser.sequence
        { start = ""
        , separator = "\n"
        , end = ""
        , spaces = Parser.Extra.spaces
        , item =
            colorParser
                |> Parser.andThen
                    (\firstColor ->
                        Parser.loop [ firstColor ]
                            (\result ->
                                Parser.oneOf
                                    [ Parser.succeed (\color -> Parser.Loop (color :: result))
                                        |= colorParser
                                    , Parser.succeed ()
                                        |> Parser.map (\() -> Parser.Done (List.reverse result))
                                    ]
                            )
                    )
        , trailing = Parser.Forbidden
        }
        |> Parser.andThen
            (\listsOfLists ->
                case Matrix.Extra.toMatrix White listsOfLists of
                    Ok matrix ->
                        if Matrix.width matrix /= size || Matrix.width matrix /= size then
                            Parser.problem
                                ("Expected a "
                                    ++ String.fromInt size
                                    ++ "x"
                                    ++ String.fromInt size
                                    ++ " matrix but got "
                                    ++ String.fromInt (Matrix.width matrix)
                                    ++ "x"
                                    ++ String.fromInt (Matrix.height matrix)
                                )

                        else
                            Parser.succeed matrix

                    Err message ->
                        Parser.problem message
            )


colorParser : Parser Color
colorParser =
    Parser.oneOf
        [ Parser.succeed White
            |. Parser.symbol "."
        , Parser.succeed Black
            |. Parser.symbol "#"
        ]


solution1 : String -> Result String Int
solution1 input =
    Ok 42


matches : Array Color -> Tile -> Int
matches wantedEdge tile =
    let
        edges =
            [ Matrix.getRow 0 tile.matrix
            , Matrix.getRow (size - 1) tile.matrix
            , Matrix.getColumn 0 tile.matrix
            , Matrix.getColumn (size - 1) tile.matrix
            ]
                |> List.filterMap Result.toMaybe
                |> List.concatMap
                    (\edge ->
                        [ edge
                        , edge |> Array.toList |> List.reverse |> Array.fromList
                        ]
                    )
    in
    edges
        |> List.filter ((==) wantedEdge)
        |> List.length


main : Html Never
main =
    Html.div []
        [ showResult (solution1 puzzleInput)
        , case parse puzzleInput of
            Ok tiles ->
                tiles
                    |> List.map
                        (\tile ->
                            let
                                others =
                                    tiles |> List.filter (\tile2 -> tile2.id /= tile.id)

                                edges =
                                    [ ( "Top", Matrix.getRow 0 tile.matrix )
                                    , ( "Bottom", Matrix.getRow (size - 1) tile.matrix )
                                    , ( "Left", Matrix.getColumn 0 tile.matrix )
                                    , ( "Right", Matrix.getColumn (size - 1) tile.matrix )
                                    ]
                                        |> List.filterMap
                                            (\( text, result ) ->
                                                result |> Result.toMaybe |> Maybe.map (Tuple.pair text)
                                            )
                                        |> List.map
                                            (Tuple.mapSecond
                                                (\edge ->
                                                    others
                                                        |> List.map (matches edge)
                                                        |> List.filter (\n -> n > 0)
                                                        |> List.length
                                                )
                                            )
                            in
                            ( tile, edges )
                        )
                    |> List.filter
                        (\( _, edges ) ->
                            edges
                                |> List.filter (\( _, n ) -> n == 0)
                                |> List.length
                                |> (\n -> n >= 2)
                        )
                    |> (\list ->
                            let
                                _ =
                                    Debug.log "product" (list |> List.map (Tuple.first >> .id) |> List.product)
                            in
                            list
                       )
                    |> List.map
                        (\( tile, edges ) ->
                            Html.div [ Html.Attributes.style "margin-top" "24px" ]
                                [ Html.div [ Html.Attributes.style "font-weight" "bold" ]
                                    [ Html.text (String.fromInt tile.id) ]
                                , edges
                                    |> List.map (\( text, num ) -> Html.div [] [ Html.text (text ++ ": " ++ String.fromInt num) ])
                                    |> Html.div []
                                ]
                        )
                    |> Html.div []

            Err message ->
                Html.text message
        ]


showResult : Result String a -> Html msg
showResult result =
    Html.output []
        [ Html.text
            (case result of
                Ok int ->
                    Debug.toString int

                Err error ->
                    error
            )
        ]


puzzleInput : String
puzzleInput =
    """
Tile 1487:
.##..#...#
##.##.....
...#....##
##..#..#.#
.####....#
.#.#..#..#
..##.....#
..##....##
#.....#..#
...#..####

Tile 3637:
##...#....
#.#..#...#
....##...#
#.........
#......#.#
##...#.#..
#.........
##.....###
##.#......
##.#.##..#

Tile 3433:
.....#..#.
##..##...#
....#.....
.........#
#........#
#..##..###
#..#..##..
#...##.#..
.#...#..#.
#.##....#.

Tile 3931:
#....##..#
...#..###.
#...#..#.#
.......#..
#.......#.
###......#
###.#.#..#
.##..#..#.
...##..#.#
..##..#.#.

Tile 2213:
.###...##.
..##......
..........
.##...#...
...##...#.
..#.#..#.#
..##......
#..#.#.###
...#......
#.#..##...

Tile 1901:
.#.##.#.#.
#.........
#.##..#.##
...###...#
.....#.#.#
.#.....#..
....#.#...
..#...#..#
#........#
####.###..

Tile 3917:
.##.#..#.#
#.##....#.
#.....#...
#.#...#.##
..........
..........
.#....#.#.
.........#
.....#....
#.#.##....

Tile 1831:
.#..#..##.
#.....##..
###....###
.#.#.##..#
#....#...#
......#.#.
.....#..##
#..##.....
####.#.##.
...##.#..#

Tile 3557:
..#.#.#.#.
##........
.......#..
.##.......
..........
....#..#..
#...#....#
#..#####.#
#..#...##.
#.....###.

Tile 2659:
####.##.#.
.##.##...#
####..#...
##........
####......
.......#.#
###....#..
.....#..##
#....#...#
.#..###.#.

Tile 3061:
.#..#.#..#
........#.
##.#....#.
###....#..
.........#
..#..#....
....#..#.#
.#.##...##
##.#....##
.#.#.##.##

Tile 3593:
###.#.####
.#........
#..#....#.
.......###
.#....##.#
....#..##.
#.#.....##
#..#...#..
.#......#.
#....##..#

Tile 2719:
..###.#..#
..##...##.
..##.....#
#.......#.
...#....##
#.#....#..
#.......#.
#..#.....#
........##
.#.#..##.#

Tile 3089:
##.#.#.#.#
.#..#....#
.#.#.....#
##...#.#.#
.......#..
###..####.
....#.....
........#.
.#.....##.
..####..#.

Tile 1723:
..#.##.###
#..###.#.#
..#..#...#
....#.#...
....#....#
#....#....
#.....#...
#.#..#.#..
#...###..#
###.####..

Tile 2297:
.##....#.#
####..#.##
#.##...##.
#.##...#.#
###.##..##
....#...##
##....##.#
..##...##.
##.#.#..#.
#...#.##..

Tile 3659:
.#####....
....#.#.##
.#..#....#
....#....#
.....#...#
.....#..##
##..#.....
##...#....
####....##
##......#.

Tile 1847:
###.#.####
..##.....#
#.......#.
##......#.
..#.#.....
#.......#.
.#..#...#.
.#......#.
#.....###.
##.###.##.

Tile 1601:
#.#.##.###
.#..#...#.
##...#..#.
#.#####..#
.......#.#
##..##.##.
..#.#..#..
..###....#
.....#...#
....#####.

Tile 3323:
..#..##.##
##......##
###.#...#.
.#..#..#..
#...#..###
#....##...
##.....#.#
...####...
....#.....
..##....##

Tile 1321:
###.######
#...#.#..#
##........
#..#..#.#.
..##.#..#.
.........#
.#.......#
#..#......
##.#.....#
.###...#.#

Tile 2551:
....##...#
...#.##...
.##.......
...#..#...
#.#...##.#
#..##.#...
.##..#.##.
##....#..#
...#.....#
..#.#.#.#.

Tile 2503:
...#..##.#
.........#
#.#....##.
#.........
##..#.#...
#...#..#..
...#......
.##.##....
#.........
###.....##

Tile 1163:
#.####..#.
.##.#.#...
#.#..#####
......#...
##....#..#
#.......##
#.#.##..#.
##...###.#
#.........
.##.#...##

Tile 1039:
#.###.#.#.
.##......#
.#...#..#.
.#...#...#
#.#...#..#
##.#...#..
#.##......
#.#.#..#..
##...#..##
#.####..##

Tile 2953:
...#.#.#.#
..#.#.....
.........#
#..#...#.#
......#...
.........#
....#..#..
.###....#.
##.##..###
..####.#..

Tile 1609:
...#...#..
#....##..#
...###.#..
#.##.##..#
#.#.##.#..
##.......#
.##...#..#
#....#....
........#.
.....#..#.

Tile 1187:
####.##...
..........
.....#...#
#.#......#
#....#.###
.#..###.#.
##...#....
......#..#
....#.#..#
#####...##

Tile 3313:
#######..#
#.#...####
..........
#.#..##...
###......#
##........
##......##
##..#.#...
..#..#..#.
#..#...##.

Tile 3221:
....#.#.#.
##..#.....
.#.##..#..
#..##..#.#
....#....#
##.......#
#.......#.
#.###...##
#..#......
#....##...

Tile 2647:
.##.#.####
..#.......
#...##....
#..#....##
......#...
..##......
.#.....#.#
###.##....
###...###.
##.#.#..#.

Tile 2879:
#.#.#..###
......####
##....#.#.
.#.......#
....##..#.
#..#.###.#
#.........
##.......#
#...##...#
..#...##.#

Tile 2423:
.###.#..#.
..###.##..
..#.#...##
#....#...#
#..#.##...
#..#....##
.....#....
##.##....#
....#....#
...#..#.#.

Tile 2557:
.#..#..##.
#....##.##
...#.#...#
#...####..
#........#
...#....##
..........
.##..#.##.
#.#..#...#
.###..#.#.

Tile 2819:
..#......#
#....#....
##..#...##
#......###
#..##.....
#.###.#...
.##...####
..........
#........#
#...##.#.#

Tile 2531:
....#.#..#
..#..#..#.
#....#...#
#..#..#..#
.........#
#.#.......
#......###
#.#...##..
#....###.#
.#.#####.#

Tile 1109:
..#.#.#.##
.....#....
#...##.#.#
##.##.#...
.........#
.#..#.#..#
#.........
.##...#..#
#.#..#..#.
.#.###.#..

Tile 1103:
#..##.#...
.###......
#..#.....#
.....###.#
.#..#.##.#
......##.#
#...##.#..
...#...###
.##..#.##.
.#.#.#..#.

Tile 2713:
.###.##...
#.##...#.#
.....#...#
#.........
##...#..##
.###.#.##.
#.#..##.##
#...#..##.
...#...##.
.....#.##.

Tile 2927:
##..#...#.
...#..#..#
#..#..#...
.....#.#..
##.......#
...##.##.#
#.#.......
.###....#.
....#.####
####.###.#

Tile 3319:
....#.#.##
#.###..###
.#....#.#.
.....#..#.
.##....#..
....#...##
#.#...#...
.......#..
#.#.###.#.
......##..

Tile 2311:
#.#.##...#
..#....#..
..#..#..#.
..#.#.#.##
......####
..#..#..##
##....##.#
.#..#.....
.....##..#
...##.....

Tile 1549:
##.#.#.#.#
##..#...#.
.#....#...
.#....##.#
..#..###.#
#....#..##
.#.......#
#.....#.##
.....#....
#.#...#.#.

Tile 3631:
...#.###.#
........#.
###..##..#
###.....#.
##....##.#
....#.....
###.#.#...
...#..#...
##..#....#
....##..#.

Tile 1787:
#.##.##.#.
....#...#.
#..#..#..#
...#.....#
#.##.#....
##.......#
#.....#...
#...##.#..
.#.##.#..#
###.#....#

Tile 3467:
########.#
##...#.#.#
...#......
.....#.#.#
#.....#..#
#........#
...#......
..#.....##
.#.##..#..
..#.....#.

Tile 3373:
##..#.#..#
...#......
###.##..#.
#........#
.#...#...#
#....##...
.#.....#..
.#....#..#
#.#..####.
...####.#.

Tile 3911:
#.###.#..#
.##......#
...#......
#...#..##.
.......#.#
#.#......#
...##..#.#
##..#..#.#
#......##.
#####..###

Tile 1327:
...#.#..#.
.........#
#..#...#..
#........#
###.#.....
.........#
##.#......
#........#
#..#...#.#
.#.##..##.

Tile 3643:
.#.#...#.#
#.##....#.
#..#...#..
....##....
#....##.##
..........
#...#.#.##
##.#..#..#
...#....##
..##..#..#

Tile 2447:
#...#.###.
#.....#..#
#.#.......
###..#...#
.....##.##
#....#...#
#.#.#.....
#.....#...
...##.....
.#.###.##.

Tile 3181:
.###..#...
##...#.#.#
#..#......
#......#.#
.#...##.#.
#.#......#
.........#
.........#
#.#...#...
##.##.#.#.

Tile 3037:
#########.
...#.#...#
.##......#
.#........
#....#...#
#..#..#.#.
...###.#.#
#.#...#.##
##..#.#..#
#..#.##.#.

Tile 3671:
##.#.#....
........#.
##.#....#.
#.##.#.#.#
##....##..
.##...#.#.
.#.#...#..
##...##..#
#.#....###
##.#..###.

Tile 2909:
.##...###.
#.....#..#
.#..#.....
#.###.#.##
#.##.#.##.
..#......#
.#..#.#...
#..#..#.#.
.#.#...#..
.###..##.#

Tile 3571:
..#.#.#..#
#....#....
.....##..#
.....###.#
....#.#...
......#..#
#.......##
..........
..#.##..#.
##.##.##.#

Tile 1931:
###.##...#
#...#.#...
#..#..#.##
..##......
...##....#
#.#.##..##
#.##.....#
#..#......
..#..#.#.#
....##.#.#

Tile 2689:
#....#.##.
....#...##
......##..
#....#...#
........#.
..........
##.#.###..
..#.......
....##....
...#.#..##

Tile 3499:
.#.###.#.#
......#..#
..#......#
.#......#.
##.......#
##...##...
.#......#.
#......#..
#....#....
###.######

Tile 1277:
...##.#...
......#..#
###......#
#.........
..##.....#
#.#....###
#.........
#..#.....#
#.........
###.#.#...

Tile 2633:
.#..#.##..
#........#
......#..#
..#.......
.##....#.#
#.......#.
.#.##.....
#.........
........#.
##.#.#####

Tile 1699:
.##.#..##.
#..##.....
...#...##.
..#....#..
#..#..##.#
..#.....##
.##......#
..#....#..
#..###..#.
#..#.####.

Tile 2339:
.#.#####..
##.#...#..
..##.#....
.###....#.
#..##....#
#.........
.....#....
#...#....#
#..##...#.
#....##...

Tile 1993:
.####.....
.....#..#.
..#.#..#.#
#........#
...##.#.#.
..#.#.#..#
.###.##.#.
..#.#..#..
....#####.
..#.#...##

Tile 2467:
.####..#.#
#####.....
##...##...
#....##.##
.....###..
#....###.#
......#..#
....##.#..
....##.#..
..#...#.#.

Tile 2153:
.##.##.#.#
.........#
....#..##.
...#......
#..#....##
....#....#
..##.#...#
........#.
##..#.##.#
..#.##....

Tile 1867:
.#....####
#...#....#
....#..#..
.#.....###
....#..#.#
#..#..#..#
....#...#.
.....#...#
.....##...
.##..#.#.#

Tile 2111:
..#.#..###
.....#....
..#.#.##..
.#.......#
..#.......
..#..#.#..
.#.....#..
....#....#
##.#...#..
####.##...

Tile 3307:
.#.#..####
###..#.#..
........##
.....#..#.
.#....##..
###.#....#
.#........
.......#..
#.#.....##
..#.#..##.

Tile 1061:
##.##.....
#..#.#..#.
..#....#..
#.....#..#
#.#..#...#
#.....####
#....#....
##......##
......##.#
##...##...

Tile 1021:
##.###.##.
.#....#..#
#.....#..#
#..#..##.#
##.....#.#
#.#....##.
..#.....#.
.#.....#.#
.#..#.....
.....#.##.

Tile 3677:
.#...#...#
..........
....###...
.######..#
..#...#...
#...#.#...
##.......#
..#......#
.#..#....#
#..##.####

Tile 1231:
#.###.##..
..#.......
#..#.....#
#..#.....#
.#.....#.#
##......##
.#.###....
..#....###
##.....#.#
##.....#..

Tile 3301:
.........#
.#..#....#
##.#...#.#
..#..#...#
.##....##.
..#...#...
##.##....#
#..#.#....
.....#..##
#...#..###

Tile 2861:
.....#.###
.#####.###
###.#...#.
##..###..#
..........
##...#.#..
##..#..#..
.##..#...#
#.....#...
.....###..

Tile 3823:
.##.##.###
..#.#.....
#.#####.#.
.#......##
#.#..#.#.#
...#..##.#
##..##...#
....#..#..
....#....#
##.#......

Tile 2027:
.#.#..#..#
....#.....
.#..##....
#..###..##
#...#.....
#...#...##
.#........
##.##.#...
.....#.#..
###..##.##

Tile 3673:
....####.#
.#...###.#
....#..#..
.#.#.#....
..#..#....
#....##.#.
.....#....
#...#....#
#..#.#....
###.#.#...

Tile 1777:
.####.####
#..#....#.
....###...
.....#.#..
....#.....
.#........
##.#.....#
.#.......#
.#...#...#
.####.#.##

Tile 2609:
.#.#####..
......#..#
#.#.#.....
..##...#..
....#....#
#....#...#
..#.#...##
#...#...##
#..#.....#
###..#....

Tile 2687:
##...#.#.#
.####.....
#.#..#..#.
#...##...#
#....#.##.
.##......#
#..##..#..
.#.#.#..#.
#.#.##..##
##..#...#.

Tile 1451:
######.#..
##.###...#
...##.....
#..##...#.
.....#..#.
#..#..#...
..#...#...
##..##...#
#......##.
..#..#.#..

Tile 3251:
.####..##.
#.........
##..###...
#......#..
##..##..#.
..........
#........#
#........#
..##.#.###
........#.

Tile 3391:
..#######.
#..#.#...#
.......#..
#...#....#
#.....#..#
##........
#.....#..#
.....#..##
..###...##
.#..#.#.#.

Tile 1129:
.##..#.#..
##.#.#....
###...#..#
..........
......####
..........
##...#...#
#.#...#.##
#.........
###...####

Tile 2087:
..###.#...
#...##...#
...#.....#
..##...#..
##.....#.#
####.....#
..#.#..#..
#.#.##....
..###....#
.#.#.##.#.

Tile 1361:
#...######
...#......
#.#.#.#..#
#.....#.##
....#...##
#.......##
#......#..
#.....#..#
..#....#.#
.....##.#.

Tile 1583:
#.#..##.#.
#..#.#....
#...#..#..
##.....#.#
#...#.#...
...###....
..#..#.##.
...####..#
#....#....
#..#.##.#.

Tile 3361:
.###.#####
.##..#...#
.....##...
#.#....#..
#..#...#..
.........#
#........#
..#.......
#.###.....
#...###...

Tile 3463:
.....###.#
...##.#..#
.#...#....
###.##..#.
#.###...#.
#..#..#...
#..##.....
#..#...#.#
#........#
.###..#.#.

Tile 1997:
#.##....#.
..#...#...
#........#
.....#.#.#
.#...#....
#..#.#....
##...#....
##.....#.#
#.........
#.......##

Tile 2131:
.##.##.#..
...#.#...#
###.####.#
......###.
.#.#..#.##
..#..#.###
......#.##
..##..#..#
...#.#....
###.####..

Tile 3943:
###..#####
.#.#...#.#
##..#.#.##
#..#....##
#...#....#
#..#..##.#
..#....##.
#.......##
#.........
..##...##.

Tile 1481:
.###...#.#
####.##.#.
.###.##.#.
...#.#...#
#...#....#
.#.....#..
..##....##
##.##..###
.....#...#
###.##.#.#

Tile 3191:
..#.###.##
#...#...#.
#....#....
..#.....#.
...#..#.##
........##
#..#......
#.........
.#........
.......##.

Tile 3833:
......#...
.......#..
......#.#.
...#.....#
...##.#.#.
.#.....###
#..##..#..
....#....#
.#..#..#..
#.##..#.#.

Tile 1627:
###...####
#.........
#..#..###.
.....##..#
#....#....
#.##..##.#
....#..##.
...##...#.
.###..#...
..#.##.###

Tile 2801:
#####.###.
..#.##.###
.##...##.#
#.......##
.......#..
..........
......#..#
#.....#..#
##..#.###.
.#..#.#.##

Tile 1889:
##.#....##
..###....#
#..#.....#
.#......##
##..#.#...
....#...##
......#...
#.##....#.
...##..#..
.##.#.#...

Tile 1823:
....#.#.#.
.#........
#...##...#
...####..#
...#...###
#...#..#..
#.#..#....
#...#..#.#
......#...
###.###.#.

Tile 2663:
##.##.#.##
.#.#.....#
.#.##....#
#....#...#
#..#..##..
#.###...#.
.......#.#
#..#......
.....#....
.##...#...

Tile 1091:
.##...#.##
#.....#...
####.....#
.......#..
...#......
#.#..#...#
#.#.....##
##......#.
..#.......
.#.#...##.

Tile 3163:
#####..#.#
####..#.#.
.##.#..###
...#....#.
.........#
..#......#
##.....#.#
#.....#..#
#..#...#.#
.####..##.

Tile 1031:
.#.##.#...
##.##..#.#
.....#....
#..#......
......#...
.....#.#..
.....#.#.#
.#...#....
.##....##.
.#.##....#

Tile 2269:
####.####.
#.........
#...##.##.
..##..#..#
...#......
.#....#..#
#..##....#
..........
..#.....#.
.####...##

Tile 3793:
.##.#.###.
.##.##..##
..#...#.#.
......#..#
..####....
#........#
#....#...#
#....#.#..
.#.#..###.
#...#.###.

Tile 3079:
#.#.#.#...
##..#....#
..#...#..#
#..###....
#.#.......
..#.#.....
....#.....
###.##.###
...##.....
...###...#

Tile 3187:
.##.##.###
.#.....#.#
..##.##.#.
#.###.....
.##.##..##
#..#.....#
#...#.#..#
..#.#...##
#........#
...##.#...

Tile 1553:
.###.#..#.
.#..##.#..
#....#...#
#....##..#
#.#.##....
....#...#.
.........#
#..##..#..
.#......#.
.###.#.#..

Tile 1049:
##.#.#.###
...###.#.#
...##.....
#...#.#.#.
....##....
.##....#..
.....#.#.#
..#..#..#.
..#.#....#
....#..##.

Tile 2083:
.#......##
...#......
....#.#...
...##.#..#
#...##...#
.....#...#
..##.#...#
#....#..##
.....#....
...#..#.#.

Tile 3049:
.#...##.#.
.#..#....#
....#.##..
##..#.....
.........#
#......#..
...#.#....
...#.##.#.
.##...#..#
.##.##.#.#

Tile 3167:
..##...###
#....#..#.
#.#..#....
#.........
#..##..#.#
..........
.....#..##
.#.....##.
##......##
.##....#..

Tile 1693:
.#.###..##
#.........
##...#....
..#....#.#
...#......
...#.#...#
.#.....###
.....#####
...##....#
.#.##.....

Tile 2473:
....#.##.#
..#......#
..#......#
....#..#.#
#...#.....
..#..#..#.
.##..###.#
#.#..#....
#....##...
#.#..#.###

Tile 3821:
.#.#####.#
#.......#.
#..#.#..##
##........
.#.....#.#
.....#....
.#.#.....#
..#..##...
##..#.....
##.....###

Tile 3529:
........#.
.#....##.#
#......##.
#..#...#.#
##........
#.#...#...
...#..#.##
.#.#..#..#
#..####..#
.##..##..#

Tile 1801:
#####.#.##
#.#.......
#.#.#####.
##.#.....#
....##.#.#
#..#.#....
.#........
#.#.##...#
#.#......#
..#..#...#

Tile 3709:
.##....#..
........#.
....#.....
##..#.#...
..#..#.#..
..#.#.....
#.........
#.#.##..##
....##....
#.#.#....#

Tile 2707:
###..##.##
.#.####..#
#.#.##.#.#
#...#.#...
.......###
.....##...
...####...
###...#...
.........#
#.###.##..

Tile 3733:
##...#.##.
.....#....
#......##.
##........
##...##...
#.#...#...
#......#.#
#.#....#.#
#...#.#.##
.#..#...#.

Tile 1663:
#.#.#.###.
....##...#
...#...#.#
##...####.
.#........
##....#..#
.....#...#
#..#...#..
#######..#
##.#.#.##.

Tile 2309:
..##..#...
...#.....#
########.#
#....##..#
.#..#....#
..#.#....#
##.....#.#
..........
.#....#.##
##..#.###.

Tile 1483:
..#..#...#
##.#.#....
#.#....###
##..#.####
##.#.#.#.#
..#.#..##.
..##.....#
..#....###
#..##....#
..####..##

Tile 2591:
.#.####.##
.#.#.....#
#..##..#..
#...#.#..#
##.##.#...
.....###..
#....##..#
#....#..#.
##.#..##..
..#..#.#..

Tile 2671:
...#.###.#
#.#.....#.
.#.....#..
...##.####
.#.###..##
.#.#.#.#..
#...##..#.
#.......##
.#....##.#
.#..##..##

Tile 1051:
#.#.#.....
..#..#.##.
......#..#
#.#.......
..#.#.#..#
.#.##.#..#
#..#.###.#
#...#..###
#.......#.
...#...###

Tile 1613:
..##...#.#
#......#..
#.#..#..##
.#.#.#....
#.####.###
##..##.#..
##........
.#.#...#..
#.#....#..
.##...#.##

Tile 3457:
##.#.##..#
##.#...#.#
#..#...#.#
###....#..
.#....#...
#...##..##
..........
.........#
..#..#..#.
..#..####.

Tile 3739:
...######.
#.#.#..##.
#.#.....#.
#..#..#.##
#..#......
#.#......#
#..##.....
#.##.#....
#.#..#..#.
#.#.#..##.

Tile 2069:
....#.###.
#.#...#.#.
.##.......
..#.#.....
..........
#...#..#..
..........
###...#...
#...#.###.
.##.##..##

Tile 3623:
##..##....
#..#.#....
.....#....
#........#
.#.....#..
##..#.#.#.
#....#...#
..........
#.##.....#
#.....#..#

Tile 3613:
..#.##..#.
#...##....
.........#
#......#..
....####.#
..#.##....
..#.#...##
#.#..#....
#.#...#...
.#####.#..

Tile 3329:
##....#.#.
....#..##.
..##..#.#.
.#.##..#..
#.#.#..#..
.........#
.......#..
#..###...#
###.#.#.#.
##.#.#...#

Tile 3209:
.#.....##.
....####..
..........
..##...#..
....#...#.
#...##.#.#
#.##.###..
#...#....#
##........
..#.#####.

Tile 2351:
#....#####
#.....#...
.....#...#
#.#..#....
.#.###...#
.#...##..#
#.#......#
#....##.#.
...#....##
#####...#.

Tile 3011:
#.###....#
#...#.#..#
........##
#.....#...
..#...#.#.
......#.##
.....##..#
.##..#...#
#...#.....
#######.##

Tile 1409:
#..#..#.#.
....#..#..
#...#...##
#..#.#....
...##..#.#
#...#.....
...#.##.##
#..##.....
.#......##
.#######.#

Tile 2341:
.#.....##.
.##..#...#
.#..#.....
#........#
#..#.....#
###.......
##.##.#...
.......#.#
#.#...#...
##.#.##...

Tile 1747:
#.....#...
..##...#.#
...###....
.........#
.#..##.#..
#.##.....#
#.###..#..
#.#......#
##..##....
#.####.#.#

Tile 3881:
...###....
.........#
#...##....
#...##...#
#.#.#.#...
..#..##.#.
#....#....
#....##.##
...#......
####.##.#.

Tile 1307:
#####.##..
#...#..###
..........
##.#.....#
..#.#..##.
....#.#.#.
..........
#.........
.#.....#..
.#.#.####.

Tile 3779:
#.....####
....#...##
#...#...#.
#.....##..
#.##....#.
#..#....##
.......#..
#.#.#....#
.#..#.#...
.##..#....

Tile 2957:
.....##..#
..#....#.#
#..#...##.
.......###
...#..#.##
##......#.
.#.....##.
#...##.##.
#....#.###
..##.#..##
"""
