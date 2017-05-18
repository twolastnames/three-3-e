module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)

type Route
    = PlayersRoute
    | PlayerRoute String
    | NotFoundRoute

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PlayersRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


playersPath : String
playersPath =
    "#players"


playerPath : String -> String
playerPath id =
    "#players/" ++ id
