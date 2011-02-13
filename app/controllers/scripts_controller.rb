class ScriptsController < ApplicationController
  respond_to :json
  expose(:jsonable) do
    params[:jsonable].blank? ? :simple : params[:jsonable].to_sym
  end
  expose(:script) do
    Script.find_by_name(params[:name]).send(jsonable)
  end
  expose(:searched_scripts) do
    Script.search do
      keywords(params[:q])
      with(:script_type).any_of params[:script_type] if params[:script_type]
    end.results.map(&:simple_attributes)
  end

  def show
    respond_with(script)
  end

  def search
    respond_with(searched_scripts)
  end

end
