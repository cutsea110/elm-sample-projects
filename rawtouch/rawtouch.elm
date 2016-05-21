import Graphics.Element exposing (..)
import List
import Signal
import Touch

main : Signal Element
main = Signal.map (flow down << List.map show) Touch.touches
