module Routes exposing (view, update)

import Router exposing (Router, MessageType(..), createRouter)
import App.Model exposing (Model, Msg(..))
import Aliases exposing (UpdateFn, ViewFn)

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

view : ViewFn
view = router.view

update : Msg -> Model -> UpdateFn -> (Model, Cmd Msg)
update = router.update
