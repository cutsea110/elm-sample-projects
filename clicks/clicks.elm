import Mouse
import Signal exposing (..)
import Html exposing (Html, text)

main : Signal Html
main = Signal.map (\x -> text (toString x)) countClick

countClick : Signal Int
countClick = foldp (\clk count -> count + 1) 0 Mouse.clicks
