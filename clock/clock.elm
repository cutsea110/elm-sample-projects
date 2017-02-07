import Date exposing (Date, fromTime)
import Time exposing (Time, every, second)
import Html exposing (Html, text)

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
subscriptions model = every second Tick

view : Model -> Html Msg
view model = text (toString (fromTime model))
