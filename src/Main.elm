module Main exposing (Model, init, main, update, view)

import Browser
import Day1
import Html


type alias Model =
    String


type Msg
    = SwitchDay Int


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : Model
init =
    "init"


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text model
        , Day1.view model
        ]


update : Msg -> Model -> Model
update _ model =
    model
