module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import UrlParser exposing ( map
                          , oneOf
                          , Parser
                          , parseHash
                          , s
                          , string
                          , top
                          )


type alias StepId =
  String

type alias ScenarioId =
  String

type alias SuiteId =
  String

type Route
  = IntroductionRoute
  | SuiteRoute SuiteId
  | ScenarioRoute ScenarioId
  | StepRoute SuiteId
  | GivenRoute SuiteId
  | WhenRoute SuiteId
  | ThenRoute SuiteId
  | SuitesRoute
  | ScenariosRoute
  | StepsRoute
  | AmbassadorRoute
  | AutomaterRoute
  | ArchitectRoute
  | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map IntroductionRoute top
    , map SuiteRoute (s "suite" </> string)
    , map ScenarioRoute (s "scenario" </> string)
    , map StepRoute (s "step" </> string)
    , map GivenRoute (s "given" </> string)
    , map WhenRoute (s "when" </> string)
    , map ThenRoute (s "then" </> string)
    , map SuitesRoute (s "suites")
    , map ScenariosRoute (s "scenarios")
    , map StepsRoute (s "steps")
    , map AmbassadorRoute (s "ambassador")
    , map AutomaterRoute (s "automater")
    , map ArchitectRoute (s "architect")
    ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
