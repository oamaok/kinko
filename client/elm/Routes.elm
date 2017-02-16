module Routes exposing (view, update)

import Html exposing (Html)
import Router exposing (Router, MessageType(..), createRouter)
import App.Model exposing (Model, Msg(..))

import Pages.Login.View as LoginPage
import Pages.Files.View as FilesPage
import Pages.Files.Model as FilesModel

router : Router 
router = createRouter [
    { regex = "login"
    , roles = []
    , onEnter = Nothing
    , view = LoginPage.view
    },

    { regex = ""
    , roles = []
    , onEnter = Just <| NoParams (FilesMsg FilesModel.Init)
    , view = FilesPage.view
    }
  ]

view : Model -> Html Msg
view = router.view

update : Msg -> Model -> (Msg -> Model -> ( Model, Cmd Msg )) -> ( Model, Cmd Msg )
update = router.update
