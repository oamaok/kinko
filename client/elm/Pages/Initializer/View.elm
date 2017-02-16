module Pages.Initializer.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import App.Model as App

view : App.Model -> Html App.Msg
view model =
  div [ class "initializer" ] [
    div [ class "spinner" ] []
  ]