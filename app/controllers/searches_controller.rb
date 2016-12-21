class SearchesController < ApplicationController
  authorize_resource
  
  def show
    @query = params[:query]
    @context = params[:context]
    @search_result = Search.perform(@query, @context) if @query && !@query.blank?
  end
end
