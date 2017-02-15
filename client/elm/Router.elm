module Router exposing (Route, ViewType(..), router)

import Html exposing (Html, div)
import Regex exposing (HowMany(..), regex)

import App
import NotFound

type ViewType
  = Groups (List (Maybe String) -> App.Model -> Html App.Msg)
  | NoGroups (App.Model -> Html App.Msg)


type alias Route =
  { regex : String
  , view : ViewType
  }

type alias ScoredRoute =
  { route : Route
  , score : Int
  , groups : List (Maybe String)
  }

router : App.Model -> List Route -> Html App.Msg
router model routes =
  let
    location =
      case model.location of
        Just location -> location.hash
        Nothing -> ""
    matchingRoutes = routes
      |> List.filterMap (\route -> 
          let
            matches =
              Regex.find (AtMost 1) (regex <| "^#" ++ route.regex ++ "$") location
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
          in
            if matchLength /= 0 then
              Just <| ScoredRoute route matchLength groups
            else
              Nothing
        )
      |> List.sortBy .score
    bestRoute =
      List.head matchingRoutes
  in
    case bestRoute of
      Just scoredRoute ->
        let
          route = scoredRoute.route
        in
          case route.view of
            Groups view ->
              view scoredRoute.groups model
            NoGroups view ->
              view model
      Nothing ->
        NotFound.view model
