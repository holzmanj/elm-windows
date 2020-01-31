module Main exposing (main)

import Types exposing (CellState(..), ColorScheme, GameState, Rule)
import Array exposing (Array)
import Browser
import Html exposing (Html)
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { state : GameState
    , stepInterval : Float -- number of milliseconds between generations
    , rule : Rule
    , colorScheme : ColorScheme
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { state = Array.repeat 50 (Array.repeat 50 Dead)
      , stepInterval = 1000
      , rule = { birth = [ 3 ], survival = [ 2, 3 ] }
      , colorScheme = []
      }
    , Cmd.none
    )


type Msg
    = Start
    | Stop
    | StepGeneration


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( model, Cmd.none )

        Stop ->
            ( model, Cmd.none )

        StepGeneration ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions { stepInterval } =
    Time.every stepInterval (\_ -> StepGeneration)


view : Model -> Html Msg
view { state } =
    Html.table [] (Array.toList (Array.map viewRow state))


viewRow : Array CellState -> Html Msg
viewRow cellRow =
    Html.tr [] (Array.toList (Array.map viewCell cellRow))


viewCell : CellState -> Html Msg
viewCell cellState =
    case cellState of
        Alive ->
            Html.td [] [ Html.text "A" ]

        Dead ->
            Html.td [] [ Html.text "D" ]
