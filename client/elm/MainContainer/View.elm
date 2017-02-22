module MainContainer.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import App.Model exposing (Msg, Model)

import Navigation.View as Navigation
import ConfirmModal.View as ConfirmModal

view : Model -> List (Html Msg) -> Html Msg
view model children =
  div [ class "root" ]
    <| ConfirmModal.view model :: Navigation.view model :: children