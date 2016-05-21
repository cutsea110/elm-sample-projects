import Html exposing (Html, text)
import Mouse

main : Signal Html
main = Signal.map (text << toString) Mouse.position
