module Pages.Files.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import Aliases exposing (ViewF)
import MainContainer.View as MainContainer
import UIComponent exposing (icon)

view : ViewF
view model =
  MainContainer.view model [
    div [ class "container" ] [
      div [ class "panel" ] [
        div [ class "panel-header" ] [
          icon "list",
          text "browse"
        ],
        div [ class "panel-body" ] [
          text <| toString model.files.path
        ]
      ]
    ]
  ]