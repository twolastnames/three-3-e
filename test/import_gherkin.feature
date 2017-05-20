Feature: Script Imports Gherkin

  Scenario:  When file is valid
    Given an empty database "test_gherkin"
    Given a valid Gherkin file "import_gherkin.feature"
    When the script is executed
    Then we analyze the "When file is valid" scenario
    Then the steps are in the database
      And the scenarios are in the database
      And the scenarios have the steps
      And the scenarios have the data tied to them
      And the Scenerio has the feature "Script Imports Gherkin"
