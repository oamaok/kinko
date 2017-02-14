module Login.View exposing (view)

import Html exposing (Html, div, label, form, input, text)
import Html.Attributes exposing (class, classList, type_, value, hidden, disabled)
import Html.Events exposing (onInput, onSubmit)

import App exposing (Model, Msg)
import Auth
import Login.Update

view : Model -> Html Msg
view model =
  let
    username =
      model.login.username
    password =
      model.login.password
    loading =
      model.auth.loading
  in
    div [ classList [
      ("panel", True),
      ("login-panel", True),
      ("loading", loading)
    ] ] [
      div [ class "moeblob" ] [],
      div [ class "panel-header" ] [ text "log in" ],
      form [ class "panel-content", onSubmit <| App.AuthMsg <| Auth.Login username password ] [
        div [ class "input-group" ] [
          label [] [ text "username" ],
          input [ type_ "text", disabled loading, onInput <| App.LoginMsg << Login.Update.UsernameChange ] []
        ],

        div [ class "input-group" ] [
          label [] [ text "password" ],
          input [ type_ "password", disabled loading, onInput <| App.LoginMsg << Login.Update.PasswordChange ] []
        ],
        div [ class "error", hidden (not model.auth.error) ] [ text "log in failed." ],
        input [ type_ "submit", disabled loading, value "log in"] [],
        div [ class "spinner", hidden (not loading) ] [],
        div [ class "clearfix" ] []
      ]
    ]
