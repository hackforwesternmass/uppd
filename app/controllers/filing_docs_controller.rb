class FilingDocsController < ApplicationController
  # GET /filing_docs
  # GET /filing_docs.json
  layout "bar_right"
  
  def index
    @filing_docs = FilingDoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @filing_docs }
    end
  end

  # GET /filing_docs/1
  # GET /filing_docs/1.json
  def show
    @filing_doc = FilingDoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @filing_doc }
    end
  end

  # GET /filing_docs/new
  # GET /filing_docs/new.json
  def new
    @filing_doc = FilingDoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filing_doc }
    end
  end

  # GET /filing_docs/1/edit
  def edit
    @filing_doc = FilingDoc.find(params[:id])
  end

  # POST /filing_docs
  # POST /filing_docs.json
  def create
    @filing_doc = FilingDoc.new(params[:filing_doc])

    respond_to do |format|
      if @filing_doc.save
        format.html { redirect_to @filing_doc, notice: 'Filing doc was successfully created.' }
        format.json { render json: @filing_doc, status: :created, location: @filing_doc }
      else
        format.html { render action: "new" }
        format.json { render json: @filing_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filing_docs/1
  # PUT /filing_docs/1.json
  def update
    @filing_doc = FilingDoc.find(params[:id])

    respond_to do |format|
      if @filing_doc.update_attributes(params[:filing_doc])
        format.html { redirect_to @filing_doc, notice: 'Filing doc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filing_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filing_docs/1
  # DELETE /filing_docs/1.json
  def destroy
    @filing_doc = FilingDoc.find(params[:id])
    @filing_doc.destroy

    respond_to do |format|
      format.html { redirect_to filing_docs_url }
      format.json { head :no_content }
    end
  end
end
