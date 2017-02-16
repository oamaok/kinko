module MainContainer.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import App.Model as App

import Navigation.View as Navigation

view : App.Model -> List (Html App.Msg) -> Html App.Msg
view model children =
  div [ class "root" ] <| Navigation.view model :: children