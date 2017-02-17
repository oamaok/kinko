module Routes exposing (view, update)

import Router exposing (Router, MessageType(..), createRouter)
import App.Model exposing (Model, Msg(..))
import Aliases exposing (UpdateF, ViewF)

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

view : ViewF
view = router.view

update : Msg -> Model -> UpdateF -> (Model, Cmd Msg)
update = router.update
