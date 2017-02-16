module UIComponent exposing (..)

import Html exposing (Html, div, i, text)
import Html.Attributes exposing (class)
import App.Model as App

icon : String -> Html App.Msg
icon name =
  i [ class "material-icons" ] [ text name ]