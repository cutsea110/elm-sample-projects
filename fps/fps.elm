module Main exposing (..)

import AnimationFrame exposing (diffs)
import Html exposing (Html, text)
import Time exposing (Time)

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = Time

init : (Model, Cmd Msg)
init = (0, Cmd.none)

type Msg = Tick Time

view : Model -> Html Msg
view model = text (toString model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick t -> (t, Cmd.none)

subs : Model -> Sub Msg
subs model = diffs Tick
