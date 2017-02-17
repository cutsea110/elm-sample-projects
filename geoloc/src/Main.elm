module Main exposing (..)

import Date exposing (fromTime)
import Geocoding exposing (..)
import Geolocation exposing (..)
import Html exposing (..)
import Http exposing (Error, send, jsonBody)
import Json.Decode as Decode
import Json.Encode as Encode
import List exposing (head)
import Maybe exposing (map, withDefault)

import SharedModels exposing (GMapLoc)
import Port exposing (markerMove)

myKey : ApiKey
myKey = "AIzaSyDSb-RzqLlys7vGUjjcTHoO6bTTqIckq-0"

main : Program Never Model Msg
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
init = (initializeModel, Cmd.none)

initializeModel : Model
initializeModel = { location = Location 0 0 0 Nothing Nothing 0
                  , formattedAddress = "--"
                  }

type Msg = LocMsg Location
         | MarkerMoved
         | GeoMsg (Result Http.Error Geocoding.Response)
         | Failure

view : Model -> Html Msg
view model =
    dl []
        [ dt [] [text "formatted address"]
        , dd [] [text model.formattedAddress]
        , dt [] [text "latitude"]
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
        ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LocMsg loc -> ({model | location = loc}, Cmd.batch [ markerMove (locToGMLoc loc)
                                                           , geocodeGet loc
                                                           , areaMoved loc
                                                           ])
        MarkerMoved -> (model, Cmd.none)
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

areaMoved : Location -> Cmd Msg
areaMoved loc =
    let url = "https://localhost:4000/move-to"
        body = jsonBody (Encode.object [ ("latitude", Encode.float loc.latitude)
                                       , ("longitude", Encode.float loc.longitude)
                                       ]
                        )
        ignoreResponse = Decode.at [] Decode.string
    in Http.post url body ignoreResponse
        |> Http.send (\_ -> MarkerMoved)
