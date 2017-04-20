module Aliases exposing (..)

import Html exposing (Html)
import App.Model exposing (Model, Msg)


type alias UpdateFn =
  Msg -> Model -> ( Model, Cmd Msg )


type alias ViewFn =
  Model -> Html Msg


type alias MiddlewareFn =
  UpdateFn -> Msg -> Model -> ( Model, Cmd Msg )
