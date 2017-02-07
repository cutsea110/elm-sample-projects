import Date exposing (Date, fromTime, year, month, day, dayOfWeek, hour, minute, second)
import Time exposing (Time, every, second)
import Html exposing (Html, text)

main : Program Never Model Msg
main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = subscriptions
       }

type alias Model = Time

init : (Model, Cmd Msg)
init = (0, Cmd.none)

type Msg = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime -> (newTime, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = every Time.second Tick

view : Model -> Html Msg
view model = text (toYMDHMS (fromTime model))

toYMDHMS : Date -> String
toYMDHMS d =
    let ymd = toString (year d) ++ "-" ++ toString (month d) ++ "-" ++ toString (day d)
        w = "(" ++ toString (dayOfWeek d) ++ ")"
        hms = toString (hour d) ++ ":" ++ toString (minute d) ++ ":" ++ toString (Date.second d)
    in ymd ++ " " ++ w ++ " " ++ hms
