module Msg exposing (Msg(..))

import Draggable
import Math.Vector2 exposing (Vec2)
import Types exposing (DraggingMode)

type Msg
    = DragMsg DraggingMode (Draggable.Msg String)
    | OnDragBy Vec2
    | StopDragging
    | MakeNewWindow
    | SetActiveWindow String
    | CloseWindow String