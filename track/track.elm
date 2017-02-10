module Main exposing (..)

import AnimationFrame exposing (times)
import Color exposing (..)
import Collage exposing (..)
import Html exposing (Html)
import Element exposing (toHtml)
import Mouse exposing (..)
import Task
import Window
import Time exposing (..)

-- main = Html Msg
main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { position : Position
                   , windowSize : Window.Size
                   , ticks : Time
                   }

init : (Model, Cmd Msg)
init = (initializedModel, Task.perform Resize Window.size)

initializedModel : Model
initializedModel = Model {x = 0, y = 0} (Window.Size 0 0) 0

type Msg = Tick Time
         | Move Position
         | Resize Window.Size

view : Model -> Html Msg
view model =
    let (w, h) = (model.windowSize.width, model.windowSize.height)
        (x, y) = (model.position.x, model.position.y)
        (dx, dy) = (toFloat x - toFloat w / 2, toFloat h/ 2 - toFloat y)
        t = model.ticks
    in toHtml (collage w h
                   [ ngon 3 100 |> filled blue |> rotate (atan2 dy dx)
                   , ngon 6 30  |> filled orange |> move (dx, dy) |> rotate t
                   ])

subs : Model -> Sub Msg
subs model = Sub.batch [ Window.resizes Resize
                       , times Tick
                       , Mouse.moves Move
                       ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick t -> ({model | ticks = t}, Cmd.none)
        Move pos -> ({model | position = pos}, Cmd.none)
        Resize sz -> ({model | windowSize = sz}, Cmd.none)
