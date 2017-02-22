module ConfirmModal.Model exposing (Msg(..), Model, initialModel)

type alias ConfirmOpts appMsg =
  { title : String
  , message : String
  , callbackMessage : appMsg
  }

type Msg appMsg
  = Confirm (ConfirmOpts appMsg)
  | Close Bool

type alias Model appMsg =
  { isOpen : Bool
  , title : String
  , message : String
  , callbackMessage : Maybe appMsg
  }

initialModel : Model appMsg
initialModel =
  { isOpen = False
  , title = ""
  , message = ""
  , callbackMessage = Nothing
  }