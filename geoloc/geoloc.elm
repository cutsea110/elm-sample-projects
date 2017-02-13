module Main exposing (..)

import Date exposing (fromTime)
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
view model =
    dl []
        [ dt [] [text "latitude"]
        , dd [] [text (toString model.latitude)]
        , dt [] [text "longitude"]
        , dd [] [text (toString model.longitude)]
        , dt [] [text "accuracy"]
        , dd [] [text (toString model.accuracy)]
        , dt [] [text "altitude"]
        , dd [] [text (toString model.altitude)]
        , dt [] [text "movement"]
        , dd [] [text (toString model.movement)]
        , dt [] [text "timestamp"]
        , dd [] [text (toString (fromTime model.timestamp))]
        ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LocMsg loc -> (loc, Cmd.none)
        Failure -> (model, Cmd.none)

subs : Model -> Sub Msg
subs model = Geolocation.changes LocMsg
