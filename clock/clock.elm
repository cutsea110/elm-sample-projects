import Date exposing (..)
import Time exposing (Time, every, second)
import Signal exposing (Signal)
import Html exposing (Html, text)

main : Signal Html
main = Signal.map (text << toYMDHMS << fromTime) (every Time.second)

toYMDHMS : Date -> String
toYMDHMS d =
  let ymd = toString (year d) ++ "-" ++ toString (month d) ++ "-" ++ toString (day d)
      w = "(" ++ toString (dayOfWeek d) ++ ")"
      hms = toString (hour d) ++ ":" ++ toString (minute d) ++ ":" ++ toString (Date.second d)
  in ymd ++ " " ++ w ++ " " ++ hms
