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
        "version": "1.1"
      }
      """

  Scenario: As an API user get Script detail by Name
    When I send a GET request for "/api/v1/scripts/pathogen.vim/current"
    Then the response should be "200"
    And the JSON response should be:
      """
      {
        "description": "Pathogen...simple",
        "display_name": "pathogen.vim",
        "install_details": "http://vimpack.org",
        "name": "pathogen.vim",
        "script_id": 2332,
        "script_type": "utility",
        "summary": "Pathogen...simple",
        "repo_url": "http://github.com/vim-scripts/pathogen.vim.git",
        "script_url": "http://www.vim.org/scripts/script.php?script_id=2332",
        "latest": {
          "date": "2008-12-25",
          "filename": "pathogen.vim",
          "release_notes": "Pathogen...simple",
          "script_version": "1.1",
          "vim_version": "7.2",
          "author": {
            "email": "vimNOSPAM@tpope.com",
            "first_name": "Tim",
            "homepage": "http://top.pe",
            "last_name": "Pope",
            "user_id": 1331,
            "user_name": "tpope"
          }
        }
      }
      """

  Scenario: As an API user get Script information by Name that does not exist
    When I send a GET request for "/api/v1/scripts/im_not_here"
    Then the response should be "404"
