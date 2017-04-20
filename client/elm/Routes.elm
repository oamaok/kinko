module Routes exposing (view, middleware)

import Router exposing (Router, MessageType(..), createRouter)
import App.Model exposing (Model, Msg(..))
import Aliases exposing (MiddlewareFn, ViewFn)
import Pages.Login.View as LoginPage
import Pages.Login.Model as LoginModel
import Pages.Files.View as FilesPage
import Pages.Files.Model as FilesModel


router : Router
router =
  createRouter
    [ { regex = "login"
      , roles = []
      , onEnter = Just <| NoParams (LoginMsg LoginModel.ClearCredentials)
      , view = LoginPage.view
      }
    , { regex = ""
      , roles = []
      , onEnter = Just <| NoParams (FilesMsg FilesModel.Init)
      , view = FilesPage.view
      }
    ]


view : ViewFn
view =
  router.view


middleware : MiddlewareFn
middleware =
  router.middleware
