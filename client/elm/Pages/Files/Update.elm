module Pages.Files.Update exposing (..)

import Pages.Files.Model exposing (Model, Msg(..), initialModel)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Init ->
      ({ model | path = [(1, "test")] }, Cmd.none)
    EnterDirectory id ->
      (model, Cmd.none)
    GetDownloadLink id ->
      (model, Cmd.none)
    _ ->
      (model, Cmd.none)