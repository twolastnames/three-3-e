module ViewShell exposing(viewShell)

import Html exposing(a, nav, text, Html)
import Html.Attributes exposing(href)
import Models exposing(Model)

viewShell: Model -> Html msg
viewShell ignoredForNow =
  nav []
    [ a [href "/suites"    ] [text "Suites"    ]
    , a [href "/scenarios" ] [text "Scenarios" ]
    , a [href "/steps"     ] [text "Steps"     ]
    , a [href "/ambassador"] [text "Ambassador"]
    , a [href "/automator" ] [text "Automator" ]
    , a [href "/architect" ] [text "Architect" ]
    ]
