class DocPagesController < ApplicationController
  # GET /doc_pages
  # GET /doc_pages.json
  def index
    @search = DocPage.solr_search do
      fulltext params[:search] do
          highlight :pagetext, :stored => true
        end
      facet :tag_list
      paginate :per_page => 20
       # tags, AND'd        
      if params[:tag].present?
        all_of do
          params[:tag].each do |tag|
            with(:tag_list, tag)
          end
        end
      end
    end

    @hits = @search.hits
    @doc_pages = @search.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @doc_pages }
    end
  end

  # GET /doc_pages/1
  # GET /doc_pages/1.json
  def show
    @doc_page = DocPage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @doc_page }
    end
  end

  # GET /doc_pages/new
  # GET /doc_pages/new.json
  def new
    @doc_page = DocPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @doc_page }
    end
  end

  # GET /doc_pages/1/edit
  def edit
    @doc_page = DocPage.find(params[:id])
  end

  # POST /doc_pages
  # POST /doc_pages.json
  def create
    @doc_page = DocPage.new(params[:doc_page])

    respond_to do |format|
      if @doc_page.save
        format.html { redirect_to @doc_page, notice: 'Doc page was successfully created.' }
        format.json { render json: @doc_page, status: :created, location: @doc_page }
      else
        format.html { render action: "new" }
        format.json { render json: @doc_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /doc_pages/1
  # PUT /doc_pages/1.json
  def update
    @doc_page = DocPage.find(params[:id])

    respond_to do |format|
      if @doc_page.update_attributes(params[:doc_page])
        format.html { redirect_to @doc_page, notice: 'Doc page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @doc_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_pages/1
  # DELETE /doc_pages/1.json
  def destroy
    @doc_page = DocPage.find(params[:id])
    @doc_page.destroy

    respond_to do |format|
      format.html { redirect_to doc_pages_url }
      format.json { head :no_content }
    end
  end
end
