module Main exposing (..)

import Geolocation exposing (..)
import Html exposing (..)
import Task

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = Location

init : (Model, Cmd Msg)
init = (initializeModel, Task.attempt processLocation Geolocation.now)

processLocation res =
    case res of
        Ok loc -> LocMsg loc
        Err _ -> Failure

initializeModel : Location
initializeModel = Location 0 0 0 Nothing Nothing 0

type Msg = LocMsg Location | Failure

view : Model -> Html Msg
view model = text (toString model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LocMsg loc -> (loc, Cmd.none)
        Failure -> (model, Cmd.none)

subs : Model -> Sub Msg
subs model = Geolocation.changes LocMsg
