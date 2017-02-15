module Navigation.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import App

view : App.Model -> Html App.Msg
view model =
  div [ class "navigation" ] []
