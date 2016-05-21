import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

main : Element
main = collage 200 200
       [ filled blue (square 100)
       , filled red (square 100) |> move (toFloat 20, toFloat 20) |> rotate (toFloat 45)
       ]
