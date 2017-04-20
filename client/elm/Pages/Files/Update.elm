module Pages.Files.Update exposing (..)

import Pages.Files.Model exposing (Model, Msg(..), FileEntry, FileList, initialModel)
import Json.Decode as JD exposing (Decoder)
import Http


fileListDecoder : Decoder FileList
fileListDecoder =
  JD.list <|
    JD.map3 FileEntry
      (JD.field "id" JD.string)
      (JD.field "name" JD.string)
      (JD.field "isDirectory" JD.bool)


initFiles : Cmd Msg
initFiles =
  Http.send InitResponse (Http.get "/api/f/list" fileListDecoder)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Init ->
      ( initialModel, initFiles )

    InitResponse (Ok list) ->
      ( { model | isLoading = False, entries = list }, Cmd.none )

    InitResponse (Err _) ->
      ( model, Cmd.none )

    FilterChange filter ->
      ( { model | filter = filter }, Cmd.none )

    EnterDirectory id ->
      ( model, Cmd.none )

    GetDownloadLink id ->
      ( model, Cmd.none )

    _ ->
      ( model, Cmd.none )
