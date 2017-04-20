module Pages.Login.Update exposing (update)

import Pages.Login.Model exposing (Msg(..), Model, initialModel)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ClearCredentials ->
      ( initialModel, Cmd.none )

    UsernameChange username ->
      ( { model | username = username }, Cmd.none )

    PasswordChange password ->
      ( { model | password = password }, Cmd.none )
