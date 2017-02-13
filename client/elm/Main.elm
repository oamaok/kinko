import Html exposing (Html, button, text)
import Html.Events exposing (onClick)
import Auth
import App exposing (initialModel)
import Navigation

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
  button [ onClick <| App.Auth <| Auth.Login "test" "test" ] [ text "test" ]
