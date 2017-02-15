module Auth exposing (Msg(..), Model, initialModel, update)

import Json.Encode as JE
import Json.Decode as JD exposing (Decoder)
import Http
import Navigation

type Msg
  = Login String String
  | LoginResponse (Result Http.Error Response)
  | Logout

type alias Model = 
  { loading : Bool
  , error : Bool
  , token : String
  , username : String
  , roles : List String
  }

type alias Response =
  { token : String
  , username : String
  , roles : List String
  }

initialModel : Model
initialModel =
  { loading = False
  , error = False
  , token = ""
  , username = ""
  , roles = []
  }

loginRequest : String -> String -> Cmd Msg
loginRequest username password =
  Http.send LoginResponse (Http.post "/api/login" (loginBody username password) responseDecoder)

loginBody : String -> String -> Http.Body
loginBody username password =
  Http.jsonBody <| JE.object [("username", JE.string username), ("password", JE.string password)]

responseDecoder : Decoder Response
responseDecoder =
  JD.map3 Response (JD.field "token" JD.string) (JD.field "username" JD.string) (JD.field "roles" <| JD.list JD.string) 
  
logoutRequest : String -> Cmd Msg
logoutRequest token =
  Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Login username password ->
      ({ model | loading = True, error = False }, loginRequest username password)
    LoginResponse (Ok res) ->
      ({ initialModel | token = res.token, username = res.username, roles = res.roles }, Navigation.newUrl "#")
    LoginResponse (Err _) ->
      ({ model |  loading = False, error = True }, Cmd.none)
    Logout ->
      (initialModel, logoutRequest model.token)