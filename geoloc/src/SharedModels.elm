module SharedModels exposing (..)

import Time exposing (Time)

type alias GMapLoc = { lat : Float
                     , lng : Float
                     , tim : Time
                     , msg : String
                     }
