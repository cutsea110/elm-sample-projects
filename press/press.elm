import Graphics.Element exposing (..)
import Mouse
import Signal exposing (..)

main : Signal Element
main = map show Mouse.isDown
