module Pages.Files.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (type_, class, colspan)
import Html.Events exposing (onInput)

import App.Model as App
import Aliases exposing (ViewFn)
import MainContainer.View as MainContainer
import UIComponent exposing (icon)
import Pages.Files.Model exposing (Msg(..), FileEntry)


directoryRow : FileEntry -> Html App.Msg
directoryRow entry =
  tr [] [
    td [] [ icon "folder" ],
    td [] [ text entry.name ],
    td [ colspan 2 ] []
  ]

fileRow : FileEntry -> Html App.Msg
fileRow entry =
  tr [] [
    td [] [ ],
    td [] [
      a [] [
        text entry.name
      ]
    ],
    td [] [ icon "link" ],
    td [] [ icon "delete_forever" ]
  ]

view : ViewFn
view model =
  let
    entries = model.files.entries
      |> List.filter
        (\entry ->
          String.contains
            (String.toLower model.files.filter)
            (String.toLower entry.name)
        )
      |> List.sortBy .name
      |> List.sortBy (\entry -> if entry.isDirectory then 0 else 1)
      |> List.map (\entry -> if entry.isDirectory then directoryRow entry else fileRow entry)
  in
    MainContainer.view model [
      div [ class "container" ] [
        div [ class "panel file-browser" ] [
          div [ class "panel-header" ] [
            icon "list",
            text "browse"
          ],
          div [ class "panel-body" ] [
            form [ class "search" ] [
              label [] [
                icon "filter_list",
                text "filter"
              ],
              input [
                type_ "text",
                onInput <| App.FilesMsg << FilterChange
              ] []
            ],
            div [ class "well" ] [
              table [] [
                tbody [] entries
              ]
            ]
          ]
        ]
      ]
    ]
