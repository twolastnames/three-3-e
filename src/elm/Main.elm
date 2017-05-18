module Main exposing (..)

-- import Html exposing (text)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Routing
import ViewShell exposing(viewShell)
import Models exposing(Model)

initialModel : Routing.Route -> Model
initialModel route = { }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLocationChange location ->
          ({}, (Cmd.none))

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = viewShell
        , update = update
        , subscriptions = subscriptions
        }

-- main = viewShell
--    text "Hello World"
