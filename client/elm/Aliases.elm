module Aliases exposing (..)

import Html exposing (Html)
import App.Model exposing (Model, Msg)

type alias UpdateF = Msg -> Model -> (Model, Cmd Msg)
type alias ViewF = Model -> Html Msg