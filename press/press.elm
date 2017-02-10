module Main exposing (..)

import Html exposing (..)
import Mouse

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = Bool

init : (Model, Cmd Msg)
init = (False, Cmd.none)

type Msg = MouseUp | MouseDown

view : Model -> Html Msg
view model = text (toString model)

subs : Model -> Sub Msg
subs model = Sub.batch [ Mouse.downs (\_ -> MouseDown)
                       , Mouse.ups (\_ -> MouseUp)
                       ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MouseUp -> (False, Cmd.none)
        MouseDown -> (True, Cmd.none)
