import Graphics.Element exposing (..)
import Signal exposing (..)
import Time exposing (fps)

main : Signal Element
main = map show (foldp (+) 0 (fps 30))
