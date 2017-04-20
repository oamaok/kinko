module Pages.Login.Model exposing (Msg(..), Model, initialModel)


type Msg
  = ClearCredentials
  | UsernameChange String
  | PasswordChange String


type alias Model =
  { username : String
  , password : String
  }


initialModel : Model
initialModel =
  { username = "", password = "" }
