module ConfirmModal.Middleware exposing (middleware)
import ConfirmModal.Model exposing (Msg(Confirm, Close), Model, initialModel)

import App.Model exposing (Msg(ConfirmModalMsg))
import Aliases exposing (MiddlewareFn)

middleware : MiddlewareFn
middleware update appMsg model =
  case appMsg of
    ConfirmModalMsg msg ->
      case msg of
        Confirm {title, message, callbackMessage} ->
          let
            confirmModal =
              model.confirmModal
            updatedModel =
              { confirmModal
              | isOpen = True
              , title = title
              , message = message
              , callbackMessage = Just callbackMessage
              }
          in
            ({ model | confirmModal = updatedModel }, Cmd.none)
        Close True ->
          let
            callbackMessage =
              Maybe.withDefault appMsg model.confirmModal.callbackMessage
            updatedModel =
              { model | confirmModal = initialModel }
          in
            update callbackMessage updatedModel
        Close False ->
          let
            updatedModel =
              { model | confirmModal = initialModel }
          in
            update appMsg updatedModel
    _ ->
      update appMsg model
