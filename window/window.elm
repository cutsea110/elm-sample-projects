module Main exposing (..)

import Html exposing (..)
import Task
import Window exposing (..)

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { size : Window.Size
                   }

init : (Model, Cmd Msg)
init = (Model (Window.Size 0 0), Task.perform (\_ -> Fail) Window.size)

type Msg = Resize Window.Size
         | Fail

subs : Model -> Sub Msg
subs model = Window.resizes Resize

view : Model -> Html Msg
view model = text (toString model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Resize newSize ->
            ({model | size = newSize}, Cmd.none)
        Fail -> (model, Cmd.none)
