module NotFound exposing (view)

import Html exposing (Html, text)

import App

view : App.Model -> Html App.Msg
view model =
  text "not found"