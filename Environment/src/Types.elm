module Types exposing (DraggingMode(..), ResizeDirection(..))


type DraggingMode
    = NoDrag
    | Moving
    | Resizing ResizeDirection


type ResizeDirection
    = N
    | S
    | E
    | W
    | NW
    | NE
    | SW
    | SE
