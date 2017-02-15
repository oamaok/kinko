module Pages.Login.Model exposing (Model, initialModel)

type alias Model = {
  username : String,
  password : String
}

initialModel : Model
initialModel =
  { username = "", password = "" }