module Main exposing (..)

-- import Html exposing (text)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Routing
import View exposing(view)
import Models exposing(Model)


initialModel : Routing.Route -> Model
initialModel route =
    Models.Empty


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLocationChange location ->
            let
                _ = Debug.log "in location change" location
            in
                case location.hash of
                    "#steps" ->
                        (Models.Operations, (Cmd.none))
                    _ ->
                        (Models.Empty, (Cmd.none))

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        _ = Debug.log "in subscriptions" model
    in
        Sub.none


main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- main = viewShell
--    text "Hello World"
