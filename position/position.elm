module Main exposing (..)

import Html exposing (..)
import Mouse exposing (..)

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = Position

init : (Model, Cmd Msg)
init = ({x = 0, y = 0}, Cmd.none)

type Msg = MouseMsg Position

view : Model -> Html Msg
view model = text (toString model)

subs : Model -> Sub Msg
subs model = Mouse.moves MouseMsg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MouseMsg pos -> (pos, Cmd.none)
