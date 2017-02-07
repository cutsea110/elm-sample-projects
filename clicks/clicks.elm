import Html exposing (Html, text, div)
import Mouse exposing (..)

main : Program Never Model Msg
main = Html.program { init = init
                    , view = view
                    , update = update
                    , subscriptions = subscriptions
                    }

type alias Model = Int

init : (Model, Cmd Msg)
init = (0, Cmd.none)

type Msg = Click

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Click -> (model + 1, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Mouse.clicks (\_ -> Click)

view : Model -> Html Msg
view model = Html.text (toString model)
