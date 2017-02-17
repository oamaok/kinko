module Router exposing (Route, Router, MessageType(..), createRouter)

import Regex exposing (HowMany(..), regex)

import Aliases exposing (ViewF, UpdateF)
import App.Model as AppModel exposing (Model, Msg(..))
import Pages.NotFound.View as NotFound

type MessageType
  = NoParams Msg
  | Params (List (Maybe String) -> Msg)

type alias Route =
  { regex : String
  , roles : List String
  , onEnter : Maybe MessageType
  , view : ViewF
  }

type alias Router =
  { view : ViewF
  , update : Msg -> Model -> UpdateF -> (Model, Cmd Msg)
  }

type alias ScoredRoute =
  { route : Route
  , score : Int
  , groups : List (Maybe String)
  }

-- Finds the best route matching route for the pathname
bestRoute : Model -> List Route -> String -> Maybe (Route, List (Maybe String))
bestRoute model routes pathname =
  let
    roles =
      model.auth.roles
    matchingRoutes = routes
      |> List.filterMap (\route -> 
          let
            matches =
              Regex.find (AtMost 1) (regex <| "^/" ++ route.regex ++ "$") pathname
            match =
              List.head matches
            matchLength =
              case match of
                Just m -> String.length m.match
                Nothing -> 0
            groups = 
              case match of
                Just m -> m.submatches
                Nothing -> []
            -- Check if the current user has all the needed roles for the route
            hasRoles = (route.roles
              |> List.all ((flip List.member) roles))
              -- If the route has zero required roles return true
              || List.length route.roles == 0
          in
            if matchLength /= 0 && hasRoles then
              Just <| ScoredRoute route matchLength groups
            else
              Nothing
        )
      |> List.sortBy .score
      |> List.reverse
      |> List.map (\a -> (a.route, a.groups))
  in
    List.head matchingRoutes

createRouter : List Route -> Router
createRouter routes =
  let
    view : ViewF
    view model =
      let
        pathname =
          case model.location of
            Just location -> location.pathname
            Nothing -> ""
        bestRoute_ = bestRoute model routes pathname
      in
        case bestRoute_ of
          Just (route, _) ->
            route.view model
          Nothing ->
            NotFound.view model

    routerUpdate : Msg -> Model -> UpdateF -> (Model, Cmd Msg)
    routerUpdate msg model update =
      case msg of
        -- The only case the router should handle
        UrlChange location ->
          let
            bestRoute_ =
              bestRoute model routes location.pathname
            updatedModel =
              { model | location = Just location }
          in
            case bestRoute_ of
              Just (route, groups) ->
                case route.onEnter of
                  Just onEnter -> 
                    case onEnter of
                      Params onEnterMsg ->
                        update (onEnterMsg groups) updatedModel
                      NoParams onEnterMsg ->
                        update onEnterMsg updatedModel
                  Nothing ->
                    (updatedModel, Cmd.none)
              Nothing ->
                (updatedModel, Cmd.none)

        -- If the message is not an url change, let the actual update function handle it
        _ -> update msg model
  in
    Router view routerUpdate
