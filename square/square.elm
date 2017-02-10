module Main exposing (..)

import Html exposing (Html)
import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)

main : Html ()
main = toHtml g

g : Element
g = collage 200 200
       [ filled blue (square 100)
       , filled red (square 100) |> move (toFloat 20, toFloat 20) |> rotate (toFloat 45)
       ]
