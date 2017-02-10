module Main exposing (..)

import AnimationFrame exposing (diffs)
import Html exposing (Html, text)
import Time exposing (Time)
import Mouse exposing (..)

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { total: Time
                   , state: Bool
                   , position : Position
                   }

init : (Model, Cmd Msg)
init = ({total = 0, state = False, position = {x = 0, y = 0}}, Cmd.none)

type Msg = Tick Time | MouseUp | MouseDown | MouseMove Position

view : Model -> Html Msg
view model = text (toString model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick t -> if model.state
                  then ({model | total = model.total + t}, Cmd.none)
                  else (model, Cmd.none)
        MouseDown -> ({model | state = True}, Cmd.none)
        MouseUp -> ({model | state = False}, Cmd.none)
        MouseMove pos -> ({model | position = pos}, Cmd.none)

subs : Model -> Sub Msg
subs model =
    Sub.batch [ Mouse.downs (\_ -> MouseDown)
              , Mouse.ups (\_ -> MouseUp)
              , Mouse.moves MouseMove
              , diffs Tick
              ]
