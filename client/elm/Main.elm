import Html exposing (Html)
import Navigation

import App exposing (initialModel)
import Login.View as LoginView

main : Program Never App.Model App.Msg
main =
  Navigation.program App.UrlChange
    { init = init
    , view = view
    , update = App.update
    , subscriptions = (\_ -> Sub.none)
    }

init : Navigation.Location -> (App.Model, Cmd App.Msg)
init loc =
  ({ initialModel | location = Just loc }, Cmd.none)

view : App.Model -> Html App.Msg
view model =
  LoginView.view model
