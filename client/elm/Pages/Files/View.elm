module Pages.Files.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (type_, class)

import Aliases exposing (ViewFn)
import MainContainer.View as MainContainer
import UIComponent exposing (icon)

view : ViewFn
view model =
    MainContainer.view model [
      div [ class "container" ] [
        div [ class "panel" ] [
          div [ class "panel-header" ] [
            icon "list",
            text "browse"
          ],
          div [ class "panel-body" ] [
            form [ class "" ] [
              label [] [
                icon "search",
                text "search"
              ],
              input [ type_ "text" ] []
            ],
            div [ class "" ] [
              table [] [
                tbody [] [

                ]
              ]
            ]
          ]
        ]
      ]
    ]
