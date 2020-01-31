module WindowGroup exposing (WindowGroup, activeWindow, closeWindow, dragActiveWindowBy, initWindowGroup, newWindow, setActiveWindow, setDragMode, stopDragging, windowGroupView)

import Html exposing (Html)
import Html.Attributes as A
import Math.Vector2 exposing (Vec2)
import Msg exposing (Msg(..))
import Types exposing (DraggingMode(..))
import Window exposing (Window, activeWindowView, dragWindowBy, resizeWindowBy, windowView)


type alias WindowGroup =
    { windows : List Window
    , idCtr : Int
    , dragMode : DraggingMode
    }


initWindowGroup : WindowGroup
initWindowGroup =
    { windows = [], idCtr = 0, dragMode = NoDrag }


activeWindow : WindowGroup -> Maybe Window
activeWindow { windows } =
    List.head windows


inactiveWindows : WindowGroup -> List Window
inactiveWindows { windows } =
    case List.tail windows of
        Nothing ->
            []

        Just list ->
            list


newWindow : WindowGroup -> WindowGroup
newWindow ({ windows, idCtr } as windowGroup) =
    let
        new =
            Window.makeWindow (String.fromInt idCtr) 0 0
    in
    { windowGroup | windows = new :: windows, idCtr = idCtr + 1 }


closeWindow : Window.Id -> WindowGroup -> WindowGroup
closeWindow id ({ windows } as windowGroup) =
    let
        windows_ =
            List.filter (\w -> w.id /= id) windows
    in
    { windowGroup | windows = windows_ }


setActiveWindow : Window.Id -> WindowGroup -> WindowGroup
setActiveWindow id ({ windows } as windowGroup) =
    let
        newInactive =
            List.filter (\w -> w.id /= id) windows

        newActive =
            List.filter (\w -> w.id == id) windows
    in
    { windowGroup | windows = newActive ++ newInactive }


updateActiveWindow : Window -> WindowGroup -> WindowGroup
updateActiveWindow newActive windowGroup =
    { windowGroup | windows = newActive :: inactiveWindows windowGroup }


dragActiveWindowBy : Vec2 -> WindowGroup -> WindowGroup
dragActiveWindowBy delta windowGroup =
    case activeWindow windowGroup of
        Nothing ->
            windowGroup

        Just active ->
            case windowGroup.dragMode of
                NoDrag ->
                    windowGroup

                Moving ->
                    windowGroup |> updateActiveWindow (dragWindowBy delta active)

                Resizing dir ->
                    windowGroup |> updateActiveWindow (resizeWindowBy delta dir active)


stopDragging : WindowGroup -> WindowGroup
stopDragging windowGroup =
    { windowGroup | dragMode = NoDrag }


setDragMode : DraggingMode -> WindowGroup -> WindowGroup
setDragMode newDragMode windowGroup =
    { windowGroup | dragMode = newDragMode }


inactiveWindowsViewIter : List Window -> Int -> List (Html Msg)
inactiveWindowsViewIter windows layer =
    case windows of
        [] ->
            []

        x :: xs ->
            windowView x layer :: inactiveWindowsViewIter xs (layer + 2)


windowGroupView : WindowGroup -> Html Msg
windowGroupView windowGroup =
    let
        baseElement =
            Html.div
                [ A.class "window-group-wrapper" ]

        inactiveWindowsView =
            inactiveWindowsViewIter (List.reverse (inactiveWindows windowGroup)) 1
    in
    case activeWindow windowGroup of
        Nothing ->
            baseElement []

        Just active ->
            baseElement
                (activeWindowView active :: inactiveWindowsView)
