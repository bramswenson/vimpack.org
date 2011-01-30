@sunspot
Feature: Search for vim scripts

  As an API user 
  I want to get scripts that match my search query
  So I can see what scripts there are

  Background:
    Given the pathogen.vim script exists
      And I send and accept JSON

  Scenario: As an API user I search for pathogen
    When I send a GET request for "/api/v1/scripts/search/pathogen"
    Then the response should be "200"
    And the JSON response should be:
      """
      [
        {
          "name": "pathogen.vim",
          "script_type": "utility",
          "summary": "Pathogen...simple",
          "repo_url": "http://github.com/vim-scripts/pathogen.vim.git",
          "script_version": "1.1"
        }
       ]
      """

  Scenario: As an API user get Script information by Name that does not exist
    When I send a GET request for "/api/v1/scripts/search/im_not_here"
    Then the response should be "200"
    And the JSON response should be:
    """
    []
    """
