class ScriptsController < ApplicationController
  respond_to :json
  expose(:jsonable) do
    params[:jsonable].blank? ? :simple : params[:jsonable].to_sym
  end
  expose(:script) do
    Script.find_by_name(params[:name]).send(jsonable) rescue nil
  end
  expose(:searched_scripts) do
    Script.limited_search(params)
  end

  def show
    return respond_with(script, :status => 404) if script.blank?
    respond_with(script)
  end

  def search
    respond_with(searched_scripts)
  end

end
