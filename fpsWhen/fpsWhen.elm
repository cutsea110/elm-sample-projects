module Main exposing (..)

import AnimationFrame exposing (diffs)
import Html exposing (Html, text)
import Time exposing (Time)
import Mouse

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { total: Time
                   , state: Bool
                   }

init : (Model, Cmd Msg)
init = ({total = 0, state = False}, Cmd.none)

type Dir = Up | Down
type Msg = Tick Time | MouseMsg Dir

view : Model -> Html Msg
view model = text (toString model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick t -> if model.state
                  then ({model | total = model.total + t}, Cmd.none)
                  else (model, Cmd.none)
        MouseMsg Down -> ({model | state = True}, Cmd.none)
        MouseMsg Up -> ({model | state = False}, Cmd.none)

subs : Model -> Sub Msg
subs model =
    Sub.batch [ Mouse.downs (\_ -> MouseMsg Down)
              , Mouse.ups (\_ -> MouseMsg Up)
              , diffs Tick
              ]
