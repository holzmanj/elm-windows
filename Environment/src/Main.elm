module Main exposing (main)

import Browser
import Draggable
import Draggable.Events exposing (onClick, onDragBy, onDragEnd, onDragStart)
import Html exposing (Html)
import Math.Vector2 as Vector2
import Msg exposing (Msg(..))
import Types exposing (DraggingMode(..))
import WindowGroup exposing (closeWindow, dragActiveWindowBy, newWindow, setActiveWindow, setDragMode, stopDragging)
import Workspace exposing (Workspace, initWorkspace, workspaceView)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { workspace : Workspace
    , drag : Draggable.State String
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { workspace = initWorkspace
      , drag = Draggable.init
      }
    , Cmd.none
    )


dragConfig : Draggable.Config String Msg
dragConfig =
    Draggable.customConfig
        [ onDragBy (\( dx, dy ) -> Vector2.vec2 dx dy |> OnDragBy)
        , onDragStart SetActiveWindow
        , onDragEnd StopDragging
        , onClick SetActiveWindow
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ workspace } as model) =
    let
        windowGroup =
            workspace.windowGroup

        updateWindowGroup func =
            { model | workspace = { workspace | windowGroup = windowGroup |> func } }
    in
    case msg of
        DragMsg dragMode dragMsg ->
            Draggable.update dragConfig dragMsg (updateWindowGroup (setDragMode dragMode))

        OnDragBy delta ->
            ( updateWindowGroup (dragActiveWindowBy delta), Cmd.none )

        StopDragging ->
            ( updateWindowGroup stopDragging, Cmd.none )

        MakeNewWindow ->
            ( updateWindowGroup newWindow, Cmd.none )

        SetActiveWindow id ->
            ( updateWindowGroup (setActiveWindow id), Cmd.none )

        CloseWindow id ->
            ( updateWindowGroup (closeWindow id), Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions { drag, workspace } =
    Draggable.subscriptions (DragMsg workspace.windowGroup.dragMode) drag


view : Model -> Html Msg
view { workspace } =
    workspaceView workspace
