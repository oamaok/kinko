module Navigation.View exposing (view)

import Html exposing (Html, div, a, text, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import UIComponent exposing (icon)

import App.Model as App
import Auth

view : App.Model -> Html App.Msg
view model =
  div [ class "navigation" ] [
    div [ class "container" ] [
      div [ class "brand" ] [],
      div [ class "nav-btn" ] [
        a [ onClick <| App.GoTo "/" ] [
          icon "list",
          text "browse"
        ]
      ],
      div [ class "nav-btn" ] [
        a [ onClick <| App.GoTo "/torrents" ] [
          icon "file_download",
          text "torrents"
        ]
      ],
      div [ class "nav-btn" ] [
        a [ onClick <| App.GoTo "/users" ] [
          icon "people",
          text "users"
        ]
      ],
      div [ class "nav-btn" ] [
        a [ onClick <| App.GoTo "/events" ] [
          icon "event_note",
          text "events"
        ]
      ],
      div [ class "nav-btn" ] [
        a [ onClick <| App.GoTo "/settings" ] [
          icon "settings",
          text "settings"
        ]
      ],
      div [ class "status"] [
        a [ onClick <| App.AuthMsg Auth.Logout ] [
          icon "undo",
          text <| "logout (" ++ model.auth.username ++ ")"
        ]
      ]
    ]
  ]
