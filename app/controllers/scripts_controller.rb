class ScriptsController < ApplicationController
  respond_to :json
  expose(:jsonable) do
    params[:jsonable].blank? ? :simple : params[:jsonable].to_sym
  end
  expose(:script) do
    Script.find_by_name(params[:name]).send(jsonable)
  end

  def show
    respond_with(script)
  end

end
