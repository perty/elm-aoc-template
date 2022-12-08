module Extra exposing (foldl)

import Array
import Matrix


foldl : (a -> b -> b) -> b -> (b -> b -> b) -> Matrix.Matrix a -> b
foldl function acc accJoin matrix =
    Array.foldl (\ma a -> Array.foldl function acc ma |> accJoin a) acc matrix



{-
   findPoints : (a -> Bool) -> Matrix.Matrix a -> List ( Int, Int )
   findPoints function matrix =
       let
           test : a -> { b | col : number, hits : List number } -> { col : number, hits : List number }
           test v acc =
               if function v then
                   { col = acc.col + 1, hits = acc.col :: acc.hits }

               else
                   { acc | col = acc.col + 1 }

           join : { row : Int, points : List ( Int, Int ) } -> { col : number, hits : List number } -> { row : Int, points : List ( Int, Int ) }
           join acc record =
               { row = acc.row + 1
               , points = List.append acc.points (List.map (\col -> ( acc.row, col )) record.hits)
               }
       in
       .points <|
           Array.foldl (\ma a -> Array.foldl test { col = 0, hits = [] } ma |> join a) { row = 0, points = [] } matrix
-}
