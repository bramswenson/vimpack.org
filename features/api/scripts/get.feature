Feature: Get Vim Script Info

  As an API user 
  I want to get Vim Script Info By Name
  So I can learn about the script

  Background:
    Given the pathogen.vim script exists
      And I send and accept JSON

  Scenario: As an API user get Script information by Name
    When I send a GET request for "/api/v1/scripts/pathogen.vim"
    Then the response should be "200"
    And the JSON response should be:
      """
      {
        "name": "pathogen.vim",
        "script_type": "utility",
        "summary": "Pathogen...simple",
        "repo_url": "http://github.com/vim-scripts/pathogen.vim.git",
        "script_version": "1.1"
      }
      """

  Scenario: As an API user get Script info by Name
    When I send a GET request for "/api/v1/scripts/pathogen.vim/info"
    Then the response should be "200"
    And the JSON response should be:
      """
      {
        "description": "Pathogen...simple",
        "name": "pathogen.vim",
        "script_type": "utility",
        "summary": "Pathogen...simple",
        "repo_url": "http://github.com/vim-scripts/pathogen.vim.git",
        "author": "tpope",
        "script_version": "1.1"
      }
      """

  Scenario: As an API user get Script information by Name that does not exist
    When I send a GET request for "/api/v1/scripts/im_not_here"
    Then the response should be "404"
