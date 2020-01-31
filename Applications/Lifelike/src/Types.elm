module Types exposing (CellState(..), ColorScheme, GameState, Rule)

import Array exposing (Array)


type CellState
    = Alive
    | Dead


type alias GameState =
    Array (Array CellState)


type alias Rule =
    { birth : List Int
    , survival : List Int
    }


type alias ColorScheme =
    List String
