module Main exposing (Model, init, main, update, view)

import Browser
import Day1
import Day2
import Day3
import Day4
import Day5
import Html


type alias Model =
    String


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    "init"


view : Model -> Html.Html msg
view model =
    Html.div []
        [ Html.text model
        , Day1.view model
        , Day2.view model
        , Day3.view model
        , Day4.view model
        , Day5.view model
        ]


update : msg -> Model -> Model
update _ model =
    model
