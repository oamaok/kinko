module Pages.Login.View exposing (view)

import Html exposing (Html, div, label, form, input, text)
import Html.Attributes exposing (class, classList, type_, value, hidden, disabled)
import Html.Events exposing (onInput, onSubmit)

import App.Model as App
import Aliases exposing (ViewF)
import Auth
import Pages.Login.Update as LoginUpdate

view : ViewF
view model =
  let
    username =
      model.login.username
    password =
      model.login.password
    loading =
      model.auth.loading
  in
    div [ class "login-wrapper" ] [
      div [ classList [
        ("panel", True),
        ("login-panel", True),
        ("loading", loading),
        ("error", model.auth.error)
      ] ] [
        div [ class "moeblob" ] [],
        div [ class "panel-header" ] [ text "log in" ],
        form [ class "panel-body", onSubmit <| App.AuthMsg <| Auth.Login username password ] [
          div [ class "input-group" ] [
            label [] [ text "username" ],
            input [ type_ "text", disabled loading, onInput <| App.LoginMsg << LoginUpdate.UsernameChange ] []
          ],

          div [ class "input-group" ] [
            label [] [ text "password" ],
            input [ type_ "password", disabled loading, onInput <| App.LoginMsg << LoginUpdate.PasswordChange ] []
          ],
          div [ class "error" ] [ text "log in failed." ],
          input [ type_ "submit", disabled loading, value "log in"] [],
          div [ class "spinner" ] [],
          div [ class "clearfix" ] []
        ]
      ]
    ]
