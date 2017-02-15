module Pages.Login.Update exposing (Msg(..), update)
import Pages.Login.Model exposing (Model)

type Msg
  = UsernameChange String
  | PasswordChange String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UsernameChange username ->
      ({ model | username = username }, Cmd.none)
    PasswordChange password ->
      ({ model | password = password }, Cmd.none)
