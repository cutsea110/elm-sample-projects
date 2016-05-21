import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color exposing (..)
import List
import Signal
import Time exposing (Time, every)
import Touch
import Window

main : Signal Element
main = Signal.map3 scene (every 1) Window.dimensions Touch.touches

scene : Time -> (Int, Int) -> List Touch.Touch -> Element
scene t (w, h) touches =
  let marks = List.map (makeMark t <| (toFloat w, toFloat h)) touches
  in layers [ collage w h marks ]

makeMark : Time -> (Float, Float) -> Touch.Touch -> Form
makeMark now (w, h) {x, y, id, x0, y0, t0} =
  let size = 60 + (now - t0) / 100
      clr = rgba 255 0 0 0.8
  in
    ngon 5 size
      |> filled clr
      |> move (toFloat x - w/2, h/2 - toFloat y)
      |> rotate (now - t0)
