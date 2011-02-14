class ScriptsController < ApplicationController
  respond_to :json
  expose(:jsonable) do
    params[:jsonable].blank? ? :simple : params[:jsonable].to_sym
  end
  expose(:script) do
    Script.find_by_name(params[:name]).send(jsonable)
  end
  expose(:searched_scripts) do
    script_types = params[:script_type].blank? ? Array.new : params[:script_type].split(',')
    script_types = script_types.map { |st| st.gsub('_', ' ') }
    Script.search do
      keywords(params[:q])
      with(:script_type).any_of script_types unless script_types.empty?
    end.results.map(&:simple_attributes)
  end

  def show
    respond_with(script)
  end

  def search
    respond_with(searched_scripts)
  end

end
