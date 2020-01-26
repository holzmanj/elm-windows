module Workspace exposing (Workspace, initWorkspace, workspaceView)

import Html exposing (Html)
import Html.Attributes as A
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import WindowGroup exposing (WindowGroup, initWindowGroup, windowGroupView)


type alias Workspace =
    { windowGroup : WindowGroup
    , backgroundColor : String
    }


initWorkspace : Workspace
initWorkspace =
    { windowGroup = initWindowGroup
    , backgroundColor = "teal"
    }


applicationDockView : Html Msg
applicationDockView =
    Html.div
        [ A.id "application-dock"
        , onClick MakeNewWindow
        ]
        []


workspaceView : Workspace -> Html Msg
workspaceView { windowGroup, backgroundColor } =
    Html.div
        [ A.id "workspace"
        , A.style "backgroundColor" backgroundColor
        ]
        [ applicationDockView, windowGroupView windowGroup ]
