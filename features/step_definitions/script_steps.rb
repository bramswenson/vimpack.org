Given /^the pathogen\.vim script exists$/ do
  steps %Q{ 
    Given an author "timpope" exists with user_id: "1331", user_name: "tpope", first_name: "Tim", last_name: "Pope", email: "vimNOSPAM@tpope.com", homepage: "http://top.pe"
      And a script "pathogen" exists with script_id: "2332", display_name: "pathogen.vim", name: "pathogen.vim", summary: "Pathogen...simple", script_type: "utility", description: "Pathogen...simple", install_details: "http://vimpack.org"
      And a version "1.1" exists with script: script "pathogen", author: author "timpope", filename: "pathogen.vim", script_version: "1.1", date: "2008-12-25", vim_version: "7.2", release_notes: "Pathogen...simple"
  }
end

