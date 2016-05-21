import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (on, targetValue, onKeyDown, keyCode)
import Signal exposing (..)
import List exposing (tail)
import Maybe exposing (withDefault)
import String
import Array exposing (Array)
import Json.Decode as Json
import Result exposing (..)
import Debug exposing (..)

type alias NameList = List String
type alias State = { input : String
                   , nameList : NameList
                   }
type alias Model = { state : State
                   , archive : Array State
                   , current : Int
                   }

initState : State
initState = { input = "", nameList = [] }

initModel : Model
initModel = { state = initState
            , archive = Array.fromList [ initState ]
            , current = 0
            }

type Actions = None
             | Input String
             | Add String
             | Delete ()
             | ArchiveSelect Int

appChannel : Mailbox Actions
appChannel = mailbox None

model : Signal Model
model = foldp update initModel appChannel.signal

update : Actions -> Model -> Model
update action model =
  let state = model.state
      write state' = let target = model.current + 1
                     in {model|
                          state = state'
                        , current = target
                        , archive = if target > ((Array.length model.archive) - 1)
                                    then Array.push state' model.archive
                                    else Array.set target state' model.archive
                        }
  in case action of
       Input str -> write {state| input = str}
       Add str -> write {state|
                          input = ""
                        , nameList = state.nameList ++ [str]
                        }
       Delete x -> if List.isEmpty state.nameList
                   then model
                   else write {state| nameList = Maybe.withDefault [] (tail state.nameList)}
       ArchiveSelect v -> {model|
                            current = v
                          , state = case Array.get v model.archive of
                                      Just ste -> ste
                                      Nothing -> Debug.crash "Unexpected access"
                          }
       _ -> model


view : Model -> Html
view {state, current, archive} =
  div []
      [ rangeInput ((Array.length archive)-1) current
      , textbox state.input
      , text state.input
      , div [] (List.map listHtml state.nameList)
      ]

listHtml : String -> Html
listHtml str = li [] [text str]

textbox : String -> Html
textbox str = input [ value str
                    , id "nameInput"
                    , on "input" targetValue (message appChannel.address << Input << Debug.watch "input: ")
                    , on "keydown" eventObjDecoder (message appChannel.address << Debug.watch "keydown: ")
                    ] []

rangeInput : Int -> Int -> Html
rangeInput max current =
  div [] [ div [] [ text "0"
                  , input [ type' "range"
                          , value (toString current)
                          , Attr.max (toString max)
                          , on "input" targetValue (message appChannel.address << ArchiveSelect << toInt' << Debug.watch "range: ")
                          ] []
                  , text <| toString max
                  ]
         , text (toString current)
         ]

toInt' : String -> Int
toInt' x = case String.toInt x of
             Ok x -> x
             Err str -> Debug.crash str

eventObjDecoder : Json.Decoder Actions
eventObjDecoder =
  Json.customDecoder (Json.object2 (,) keyCode targetValue)
      (\(num, str) ->
        if num == 8 && String.isEmpty str 
        then Ok (Delete ())
        else if num == 13 && (not <| String.isEmpty str)
             then Ok (Add str)
             else Err ""
      )

main : Signal Html
main = Signal.map view model
