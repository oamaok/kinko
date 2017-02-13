module App exposing (Model, Msg(..), initialModel, update)

import Auth
import Navigation

type alias Model =
  { auth : Auth.Model
  , location : Maybe Navigation.Location
  }

type Msg
  = Auth Auth.Msg
  | UrlChange Navigation.Location

initialModel : Model
initialModel =
  { auth = Auth.initialModel
  , location = Nothing
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Auth authMsg ->
      let
        (childModel, childCmd) = Auth.update authMsg model.auth
      in
        ({ model | auth = childModel }, Cmd.map Auth childCmd)
    UrlChange location ->
      ({ model | location = Just location }, Cmd.none)