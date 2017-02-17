module Pages.NotFound.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import Aliases exposing (ViewFn)
import MainContainer.View as MainContainer
import UIComponent exposing (icon)

view : ViewFn
view model =
  MainContainer.view model [
    div [ class "container" ] [
      div [ class "panel not-found" ] [
        div [ class "panel-header"] [
          icon "error_outline",
          text "not found"
        ],
        div [ class "panel-body" ] [ ]
      ]
    ]
  ]