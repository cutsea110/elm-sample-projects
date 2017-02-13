port module Port exposing (..)

import SharedModels exposing (GMapLoc)

port markerMove : GMapLoc -> Cmd msg
