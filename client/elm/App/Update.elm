module App.Update exposing (update)

import Navigation

import App.Model exposing (..)
import Auth
import Routes

import Pages.Login.Update as LoginUpdate
import Pages.Files.Update as FilesUpdate

update_ : Msg -> Model -> (Model, Cmd Msg)
update_ msg model =
  case msg of
    AuthMsg authMsg ->
      let
        authModel = model.auth
        (childModel, childCmd) = Auth.update authMsg authModel
      in
        ({ model | auth = childModel }, Cmd.map AuthMsg childCmd)
    LoginMsg pageMsg ->
      let
        (childModel, childCmd) = LoginUpdate.update pageMsg model.login
      in
        ({ model | login = childModel }, Cmd.map LoginMsg childCmd)
    FilesMsg pageMsg ->
      let
        (childModel, childCmd) = FilesUpdate.update pageMsg model.files
      in
        ({ model | files = childModel }, Cmd.map FilesMsg childCmd)
    GoTo url ->
      (model, Navigation.newUrl url)
    _ ->
      (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = Routes.update msg model update_
