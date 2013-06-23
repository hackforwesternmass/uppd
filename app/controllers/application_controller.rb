class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  def index

    unless params[:search].blank?
      @search = DocPage.solr_search do
        fulltext params[:search]
        paginate :page => params[:page] || 1, :per_page => 15
      end

      @hits = @search.hits
      @doc_pages = @search.results
    end

    respond_to do |format|
      format.html 
      format.json { render json: @doc_pages }
    end
  end
end
