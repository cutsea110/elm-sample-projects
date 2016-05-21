import Signal exposing (..)
import Time exposing (..)
import Mouse
import Graphics.Element exposing (..)

type Update = Move (Int, Int) | TimeDelta (Float, Float)

updates : Signal Update
updates = merge (map Move Mouse.position) (map TimeDelta timedelta)

timedelta : Signal (Float, Float)
timedelta = map2 (\b n -> (b, n)) Mouse.isDown (fps 30) |>
            foldp (\(b, n) (_, t) -> if b then (n, t+n) else (n, 0)) (0, 0)

main : Signal Element
main = map show updates
