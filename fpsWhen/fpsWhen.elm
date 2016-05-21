import Graphics.Element exposing (..)
import Mouse
import Signal exposing (..)
import Time exposing (fpsWhen)

main : Signal Element
main = map show (foldp (+) 0 (30 `fpsWhen` Mouse.isDown))
