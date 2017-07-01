module Models exposing(..)

type alias Step =
  { step : String
  }

type alias Given = Step
type alias When = Step
type alias Then = Step

type Operation = Given | When | Then

type alias Operations = List Operation

type Model = Operations | Operation | Empty
