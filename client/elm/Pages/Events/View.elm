module Pages.Events.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import App
import MainContainer.View as MainContainer


view : App.Model -> Html App.Msg
view model =
  MainContainer.view model
    [ div [ class "container" ]
        [ div [ class "panel" ]
            [ div [ class "panel-header" ]
                [ text "events"
                ]
            , div [ class "panel-body" ]
                [ text "events"
                ]
            ]
        ]
    ]
