module App exposing (Model, Msg(..), initialModel, update)

import Auth
import Login.Update as LoginUpdate
import Login.Model as LoginModel

import Navigation

type alias Model =
  { auth : Auth.Model
  , login : LoginModel.Model
  , location : Maybe Navigation.Location
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
      ({ model | location = Just location }, Cmd.none)