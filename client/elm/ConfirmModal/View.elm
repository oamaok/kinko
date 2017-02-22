module ConfirmModal.View exposing (view)
import ConfirmModal.Model exposing (Msg(..))

import Html exposing (div, text, button)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)

import App.Model exposing (Msg(ConfirmModalMsg))
import Aliases exposing (ViewFn)

view : ViewFn
view model =
  let
    { isOpen
    , title
    , message
    } = model.confirmModal
  in
    div [ classList [("confirm-modal", True), ("active", isOpen)] ]
    [ div [ class "panel" ]
        [ div [ class "panel-header" ] [ text title ]
        , div [ class "panel-body" ] [ text message ]
        , div [ class "panel-action" ]
          [ button [ onClick <| ConfirmModalMsg (Close False) ] [ text "cancel" ]
          , button [ onClick <| ConfirmModalMsg (Close True) ] [ text "ok" ]
          ]
        ]
    ]