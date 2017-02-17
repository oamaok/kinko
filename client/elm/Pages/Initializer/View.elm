module Pages.Initializer.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Aliases exposing (ViewF)

view : ViewF
view model =
  div [ class "initializer" ] [
    div [ class "spinner" ] []
  ]