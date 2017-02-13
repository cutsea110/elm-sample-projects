module Main exposing (..)

import Date exposing (fromTime)
import Geocoding exposing (..)
import Geolocation exposing (..)
import Html exposing (..)
import Http exposing (Error)
import List exposing (head)
import Maybe exposing (map, withDefault)
import Task

import SharedModels exposing (GMapLoc)
import Port exposing (markerMove)

myKey : ApiKey
myKey = "AIzaSyDSb-RzqLlys7vGUjjcTHoO6bTTqIckq-0"

main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subs
       }

type alias Model = { location: Location
                   , formattedAddress : String
                   }
locToGMLoc : Location -> GMapLoc
locToGMLoc loc = { lat = loc.latitude
                 , lng = loc.longitude
                 , tim = loc.timestamp
                 , msg = toString (fromTime loc.timestamp)
                 }

init : (Model, Cmd Msg)
init = (initializeModel, Task.attempt processLocation Geolocation.now)

processLocation res =
    case res of
        Ok loc -> LocMsg loc
        Err _ -> Failure

initializeModel : Model
initializeModel = { location = Location 0 0 0 Nothing Nothing 0
                  , formattedAddress = ""
                  }

type Msg = LocMsg Location | GeoMsg (Result Http.Error Geocoding.Response) | Failure

view : Model -> Html Msg
view model =
    dl []
        [ dt [] [text "latitude"]
        , dd [] [text (toString model.location.latitude)]
        , dt [] [text "longitude"]
        , dd [] [text (toString model.location.longitude)]
        , dt [] [text "accuracy"]
        , dd [] [text (toString model.location.accuracy)]
        , dt [] [text "altitude"]
        , dd [] [text (toString model.location.altitude)]
        , dt [] [text "movement"]
        , dd [] [text (toString model.location.movement)]
        , dt [] [text "timestamp"]
        , dd [] [text (toString (fromTime model.location.timestamp))]
        , dt [] [text "formatted address"]
        , dd [] [text model.formattedAddress]
        ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LocMsg loc -> ({model | location = loc}, Cmd.batch [ markerMove (locToGMLoc loc)
                                                           , geocodeGet loc
                                                           ])
        GeoMsg (Ok res) -> ({model | formattedAddress =  toAddress res.results }, Cmd.none)
        GeoMsg (Err _) -> (model, Cmd.none)
        Failure -> (model, Cmd.none)

toAddress : List GeocodingResult -> String
toAddress res = withDefault "--" (Maybe.map (\r -> r.formattedAddress) (head res))

subs : Model -> Sub Msg
subs model = Geolocation.changes LocMsg

geocodeGet : Location -> Cmd Msg
geocodeGet loc =
    Geocoding.reverseRequestForLatLng myKey (loc.latitude, loc.longitude)
        |> Geocoding.sendReverseRequest GeoMsg
