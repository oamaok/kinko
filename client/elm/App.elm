module App exposing (Model, Msg(..), initialModel, update)

import Auth
import Pages.Login.Update as LoginUpdate
import Pages.Login.Model as LoginModel

import Navigation

type alias Model =
  { auth : Auth.Model
  , login : LoginModel.Model
  , location : Maybe Navigation.Location
  , redirectLocation : Maybe Navigation.Location
  }

type Msg
  = AuthMsg Auth.Msg
  | LoginMsg LoginUpdate.Msg
  | UrlChange Navigation.Location

initialModel : Model
initialModel =
  { auth = Auth.initialModel
  , login = LoginModel.initialModel
  , location = Nothing
  , redirectLocation = Nothing
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AuthMsg authMsg ->
      let
        (childModel, childCmd) = Auth.update authMsg model.auth
      in
        ({ model | auth = childModel }, Cmd.map AuthMsg childCmd)
    LoginMsg pageMsg ->
      let
        (childModel, childCmd) = LoginUpdate.update pageMsg model.login
      in
        ({ model | login = childModel }, Cmd.map LoginMsg childCmd)
    UrlChange location ->
      let
        auth =
          model.auth
        shouldRedirectToLogin =
          String.length auth.token == 0 && location.hash /= "#login"
      in
        if shouldRedirectToLogin then
          ({ model | redirectLocation = Just location }, Navigation.newUrl "#login")
        else
          ({ model | location = Just location }, Cmd.none)