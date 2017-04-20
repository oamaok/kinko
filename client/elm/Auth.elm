module Auth exposing (Msg(..), Model, initAuth, initialModel, update)

import Json.Encode as JE
import Json.Decode as JD exposing (Decoder)
import Http
import Navigation


type Msg
  = Init Navigation.Location
  | InitResponse (Result Http.Error Response)
  | Login String String
  | LoginResponse (Result Http.Error Response)
  | Logout
  | LogoutResponse (Result Http.Error Bool)


type alias Model =
  { loading : Bool
  , error : Bool
  , isInitializing : Bool
  , isAuthenticated : Bool
  , userId : String
  , username : String
  , roles : List String
  , redirectUrl : String
  }


type alias Response =
  { userId : String
  , username : String
  , roles : List String
  }


initialModel : Model
initialModel =
  { loading = False
  , error = False
  , isInitializing = True
  , isAuthenticated = False
  , userId = ""
  , username = ""
  , roles = []
  , redirectUrl = "/"
  }


initAuth : Cmd Msg
initAuth =
  Http.send InitResponse (Http.get "/api/me" responseDecoder)


loginRequest : String -> String -> Cmd Msg
loginRequest username password =
  Http.send LoginResponse (Http.post "/api/login" (loginBody username password) responseDecoder)


loginBody : String -> String -> Http.Body
loginBody username password =
  Http.jsonBody <| JE.object [ ( "username", JE.string username ), ( "password", JE.string password ) ]


responseDecoder : Decoder Response
responseDecoder =
  JD.map3 Response
    (JD.field "id" JD.string)
    (JD.field "username" JD.string)
    (JD.field "roles" <| JD.list JD.string)


logoutRequest : Cmd Msg
logoutRequest =
  Http.send LogoutResponse (Http.get "/api/logout" JD.bool)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Init location ->
      let
        pathname =
          if location.pathname == "/login" then
            "/"
          else
            location.pathname
      in
        ( { initialModel | redirectUrl = pathname }, initAuth )

    InitResponse (Ok res) ->
      ( { model
          | isInitializing = False
          , isAuthenticated = True
          , userId = res.userId
          , username = res.username
          , roles = res.roles
        }
      , Navigation.newUrl model.redirectUrl
      )

    InitResponse (Err _) ->
      ( { model | isInitializing = False }, Navigation.newUrl "/login" )

    Login username password ->
      ( { model | loading = True, error = False }, loginRequest username password )

    LoginResponse (Ok res) ->
      ( { model | loading = False, userId = res.userId, username = res.username, roles = res.roles, isAuthenticated = True }, Navigation.newUrl model.redirectUrl )

    LoginResponse (Err _) ->
      ( { model | loading = False, error = True }, Cmd.none )

    Logout ->
      ( initialModel, logoutRequest )

    LogoutResponse (Ok res) ->
      ( { initialModel | isInitializing = False }, Navigation.newUrl "/login" )

    LogoutResponse (Err _) ->
      ( { initialModel | isInitializing = False }, Navigation.newUrl "/login" )
