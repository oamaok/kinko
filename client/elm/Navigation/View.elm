module Navigation.View exposing (view)

import Html exposing (Html, div, a, text, span)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import UIComponent exposing (icon)

import App.Model exposing (Msg(ConfirmModalMsg, AuthMsg, GoTo))
import Aliases exposing (ViewFn)
import Auth exposing (Msg(Logout))
import ConfirmModal.Model exposing (Msg(Confirm))

view : ViewFn
view model =
  let
    confirmLogout = ConfirmModalMsg
      <| Confirm
        { title = "you're about to be logged out"
        , message = "are you sure you want to be logged out?"
        , onConfirm = AuthMsg Logout
        }
  in
    div [ class "navigation" ] [
      div [ class "container" ] [
        div [ class "brand" ] [],
        div [ class "nav-btn" ] [
          a [ onClick <| GoTo "/" ] [
            icon "list",
            text "browse"
          ]
        ],
        div [ class "nav-btn" ] [
          a [ onClick <| GoTo "/torrents" ] [
            icon "file_download",
            text "torrents"
          ]
        ],
        div [ class "nav-btn" ] [
          a [ onClick <| GoTo "/users" ] [
            icon "people",
            text "users"
          ]
        ],
        div [ class "nav-btn" ] [
          a [ onClick <| GoTo "/events" ] [
            icon "event_note",
            text "events"
          ]
        ],
        div [ class "nav-btn" ] [
          a [ onClick <| GoTo "/settings" ] [
            icon "settings",
            text "settings"
          ]
        ],
        div [ class "status"] [
          a [ onClick confirmLogout ] [
            icon "undo",
            text <| "logout (" ++ model.auth.username ++ ")"
          ]
        ]
      ]
    ]
