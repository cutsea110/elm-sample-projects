module Main exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (..)
import List exposing (map, (::))
import Mouse exposing (..)
import Task
import Window exposing (..)

main : Program Never Model Msg
main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { locs : List Mouse.Position
                   , windowSize : Window.Size
                   }

init : (Model, Cmd Msg)
init = (Model [] (Window.Size 0 0), Task.perform Resize Window.size)

type Msg = MouseClick Mouse.Position
         | Resize Window.Size

view : Model -> Html Msg
view model = toHtml (elems model)

elems : Model -> Element
elems model =
    let (w, h) = (model.windowSize.width, model.windowSize.height)
        locs = model.locs
        drawPentagon pos =
            let (x, y) = (pos.x, pos.y)
            in ngon 5 20
                |> filled (hsla (toFloat x) 0.9 0.6 0.7)
                |> move (toFloat x - toFloat w / 2, toFloat h / 2 - toFloat y)
                |> rotate (toFloat x)
    in layers [ collage w h (List.map drawPentagon locs)
              , show "Click to stamp a pentagon."
              ]

subs : Model -> Sub Msg
subs model = Sub.batch [ Window.resizes Resize
                       , Mouse.clicks MouseClick
                       ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Resize sz -> ({model | windowSize = sz}, Cmd.none)
        MouseClick pos -> ({model | locs = model.locs ++ [pos]}, Cmd.none)
