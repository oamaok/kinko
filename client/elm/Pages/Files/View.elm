module Pages.Files.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (type_, class, hidden)
import Html.Events exposing (onInput)
import App.Model as App
import Aliases exposing (ViewFn)
import MainContainer.View as MainContainer
import UIComponent exposing (icon)
import Pages.Files.Model exposing (Msg(..), FileEntry)


directoryRow : FileEntry -> Html App.Msg
directoryRow entry =
  tr [ class "directory" ]
    [ td [ class "filetype" ] [ icon "folder" ]
    , td [ class "name" ]
        [ a []
            [ text entry.name
            ]
        ]
    , td [ class "tools" ] []
    , td [ class "tools" ] [ icon "delete_forever" ]
    ]


fileRow : FileEntry -> Html App.Msg
fileRow entry =
  tr [ class "file" ]
    [ td [ class "filetype" ] []
    , td [ class "name" ]
        [ a []
            [ text entry.name
            ]
        ]
    , td [ class "tools" ] [ icon "link" ]
    , td [ class "tools" ] [ icon "delete_forever" ]
    ]


nameFilter : String -> String -> Bool
nameFilter terms subject =
  String.toUpper terms
    |> String.words
    |> List.all (\word -> String.contains word (String.toUpper subject))


view : ViewFn
view model =
  let
    isLoading =
      model.files.isLoading

    entries =
      model.files.entries
        |> List.filter
            (\entry -> nameFilter model.files.filter entry.name)

    directories =
      entries
        |> List.filter .isDirectory
        |> List.sortBy .name
        |> List.map directoryRow

    files =
      entries
        |> List.filter (\entry -> not entry.isDirectory)
        |> List.sortBy .name
        |> List.map fileRow
  in
    MainContainer.view model
      [ div [ class "container" ]
          [ div [ class "panel file-browser" ]
              [ div [ class "panel-header" ]
                  [ icon "list"
                  , text "browse"
                  ]
              , div [ class "panel-body" ]
                  [ div [ class "spinner", hidden (not isLoading) ] []
                  , div [ hidden isLoading ]
                      [ div [ class "input-group search" ]
                          [ label []
                              [ icon "filter_list"
                              , text "filter"
                              ]
                          , input
                              [ type_ "text"
                              , onInput <| App.FilesMsg << FilterChange
                              ]
                              []
                          ]
                      , div [ class "well" ]
                          [ table [] [ tbody [] (List.append directories files) ]
                          ]
                      ]
                  ]
              ]
          ]
      ]
