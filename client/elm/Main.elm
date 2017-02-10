import Html exposing (Html, div, label, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model = {
  username : String,
  password : String
}

init : (Model, Cmd Msg)
init = 
  ({ username = "", password = "" }, Cmd.none)

type Msg = UsernameChange String
  | PasswordChange String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UsernameChange val ->
      ({ model | username = val }, Cmd.none)
    PasswordChange val ->
      ({ model | password = val }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = 
  Sub.batch []

view : Model -> Html Msg
view model =
  div [ class "panel login-panel" ] [
    div [ class "moeblob" ] [],
    div [ class "panel-header" ] [ text "log in" ],
    div [ class "panel-content" ] [
      div [ class "input-group" ] [
        label [] [ text "username" ],
        input [ type_ "text", onInput UsernameChange ] []
      ],

      div [ class "input-group" ] [
        label [] [ text "password" ],
        input [ type_ "password", onInput PasswordChange ] []
      ]
    ]
  ]