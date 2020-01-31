module Window exposing (Id, Window, activeWindowView, dragWindowBy, makeWindow, resizeWindowBy, windowView)

import Draggable
import Html exposing (Html)
import Html.Attributes as A
import Html.Events exposing (onClick, onMouseDown)
import Math.Vector2 exposing (Vec2, getX, getY)
import Msg exposing (Msg(..))
import Types exposing (DraggingMode(..), ResizeDirection(..))


type alias Id =
    String


type alias Window =
    { id : Id
    , top : Float
    , left : Float
    , width : Float
    , height : Float
    }


makeWindow : Id -> Float -> Float -> Window
makeWindow id top left =
    Window id top left 300 300


dragWindowBy : Vec2 -> Window -> Window
dragWindowBy delta ({ top, left } as window) =
    { window | top = top + getY delta, left = left + getX delta }


resizeWindowBy : Vec2 -> ResizeDirection -> Window -> Window
resizeWindowBy delta direction ({ top, left, width, height } as window) =
    let
        maxTop =
            (top + height) - 80

        maxLeft =
            (left + width) - 80

        minWidth =
            80

        minHeight =
            80
    in
    case direction of
        N ->
            { window
                | top = min maxTop (top + getY delta)
                , height = max minHeight (height - getY delta)
            }

        S ->
            { window | height = max minHeight (height + getY delta) }

        W ->
            { window
                | left = min maxLeft (left + getX delta)
                , width = max minWidth (width - getX delta)
            }

        E ->
            { window | width = max minWidth (width + getX delta) }

        NW ->
            resizeWindowBy delta N (resizeWindowBy delta W window)

        NE ->
            resizeWindowBy delta N (resizeWindowBy delta E window)

        SW ->
            resizeWindowBy delta S (resizeWindowBy delta W window)

        SE ->
            resizeWindowBy delta S (resizeWindowBy delta E window)


activeWindowView : Window -> Html Msg
activeWindowView window =
    Html.div [ A.class "active-window" ] [ windowView window (2 ^ 31 - 1) ]


windowView : Window -> Int -> Html Msg
windowView ({ id, top, left, width, height } as window) layer =
    let
        widthVal =
            (String.fromInt << round) width ++ "px"

        heightVal =
            (String.fromInt << round) height ++ "px"

        topVal =
            (String.fromInt << round) top ++ "px"

        leftVal =
            (String.fromInt << round) left ++ "px"
    in
    Html.div
        [ A.class "window-wrapper"
        , A.style "width" widthVal
        , A.style "height" heightVal
        , A.style "top" topVal
        , A.style "left" leftVal
        ]
        [ Html.div
            [ A.style "z-index" (String.fromInt layer)
            , A.class "window"
            , onMouseDown (SetActiveWindow id)
            ]
            [ windowTitleBarView window
            , Html.pre [] [ Html.text ("id:\t" ++ id ++ "\ntop:\t" ++ topVal ++ "\nleft:\t" ++ leftVal ++ "\nwidth:\t" ++ widthVal ++ "\nheight:\t" ++ heightVal) ]
            ]
        , windowResizeGripsView window (layer - 1)
        ]


windowTitleBarView : Window -> Html Msg
windowTitleBarView ({ id, width } as window) =
    let
        widthStr =
            (String.fromInt << round) width ++ "px"
    in
    Html.div
        [ A.style "width" widthStr
        , A.class "window-title-bar"
        , Draggable.mouseTrigger id (DragMsg Moving)
        ]
        [ windowCloseBtnView window ]


windowCloseBtnView : Window -> Html Msg
windowCloseBtnView { id } =
    Html.div
        [ A.class "window-close-btn"
        , onClick (CloseWindow id)
        ]
        [ Html.text "×" ]


windowResizeGripsView : Window -> Int -> Html Msg
windowResizeGripsView { id } layer =
    let
        nGrip =
            Html.div
                [ A.class "window-resize-grip-n"
                , Draggable.mouseTrigger id (DragMsg (Resizing N))
                ]
                []

        sGrip =
            Html.div
                [ A.class "window-resize-grip-s"
                , Draggable.mouseTrigger id (DragMsg (Resizing S))
                ]
                []

        wGrip =
            Html.div
                [ A.class "window-resize-grip-w"
                , Draggable.mouseTrigger id (DragMsg (Resizing W))
                ]
                []

        eGrip =
            Html.div
                [ A.class "window-resize-grip-e"
                , Draggable.mouseTrigger id (DragMsg (Resizing E))
                ]
                []

        nwGrip =
            Html.div
                [ A.class "window-resize-grip-nw"
                , Draggable.mouseTrigger id (DragMsg (Resizing NW))
                ]
                []

        neGrip =
            Html.div
                [ A.class "window-resize-grip-ne"
                , Draggable.mouseTrigger id (DragMsg (Resizing NE))
                ]
                []

        swGrip =
            Html.div
                [ A.class "window-resize-grip-sw"
                , Draggable.mouseTrigger id (DragMsg (Resizing SW))
                ]
                []

        seGrip =
            Html.div
                [ A.class "window-resize-grip-se"
                , Draggable.mouseTrigger id (DragMsg (Resizing SE))
                ]
                []
    in
    Html.div
        [ A.class "window-resize-grip-wrapper"
        , A.style "z-index" (String.fromInt layer)
        ]
        [ nGrip, sGrip, wGrip, eGrip, nwGrip, neGrip, swGrip, seGrip ]
