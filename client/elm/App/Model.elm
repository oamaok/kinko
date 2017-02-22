module App.Model exposing (..)

import Navigation

import Auth
import ConfirmModal.Model as ConfirmModal

import Pages.Login.Model as LoginModel
import Pages.Files.Model as FilesModel

type alias Model =
  { auth : Auth.Model
  , login : LoginModel.Model
  , files : FilesModel.Model
  , confirmModal : (ConfirmModal.Model Msg)
  , location : Maybe Navigation.Location
  }

type Msg
  = AuthMsg Auth.Msg
  | FilesMsg FilesModel.Msg
  | LoginMsg LoginModel.Msg
  | ConfirmModalMsg (ConfirmModal.Msg Msg)
  | GoTo String
  | UrlChange Navigation.Location

initialModel : Model
initialModel =
  { auth = Auth.initialModel
  , login = LoginModel.initialModel
  , files = FilesModel.initialModel
  , confirmModal = ConfirmModal.initialModel
  , location = Nothing
  }
