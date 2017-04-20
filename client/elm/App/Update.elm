module App.Update exposing (update)

import Navigation
import Aliases exposing (UpdateFn, MiddlewareFn)
import App.Model exposing (Msg(AuthMsg, LoginMsg, FilesMsg, GoTo))
import Auth
import Routes
import ConfirmModal.Middleware as ConfirmModal
import Pages.Login.Update as LoginUpdate
import Pages.Files.Update as FilesUpdate


baseUpdate : UpdateFn
baseUpdate msg model =
  case msg of
    AuthMsg authMsg ->
      let
        ( childModel, childCmd ) =
          Auth.update authMsg model.auth
      in
        ( { model | auth = childModel }, Cmd.map AuthMsg childCmd )

    LoginMsg pageMsg ->
      let
        ( childModel, childCmd ) =
          LoginUpdate.update pageMsg model.login
      in
        ( { model | login = childModel }, Cmd.map LoginMsg childCmd )

    FilesMsg pageMsg ->
      let
        ( childModel, childCmd ) =
          FilesUpdate.update pageMsg model.files
      in
        ( { model | files = childModel }, Cmd.map FilesMsg childCmd )

    GoTo url ->
      ( model, Navigation.newUrl url )

    _ ->
      ( model, Cmd.none )


middleware : List MiddlewareFn
middleware =
  [ Routes.middleware
  , ConfirmModal.middleware
  ]



-- Apply middleware update functions


update : UpdateFn
update msg model =
  (List.foldl (<|) baseUpdate middleware) msg model
