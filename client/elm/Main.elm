import Navigation

import Aliases exposing (ViewF)
import Auth
import App.Model  exposing (Model, Msg(..), initialModel)
import App.Update exposing (update)
import Routes

import Pages.Initializer.View as Initializer

main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }

init : Navigation.Location -> (Model, Cmd Msg)
init location =
  update (AuthMsg <| Auth.Init location) initialModel

view : ViewF
view model =
  if model.auth.isInitializing then
    Initializer.view model
  else
    Routes.view model