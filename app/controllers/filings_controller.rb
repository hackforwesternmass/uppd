class FilingsController < ApplicationController
  # GET /filings
  # GET /filings.json
  def index
    @filings = Filing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @filings }
    end
  end

  # GET /filings/1
  # GET /filings/1.json
  def show
    @filing = Filing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @filing }
    end
  end

  # GET /filings/new
  # GET /filings/new.json
  def new
    @filing = Filing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filing }
    end
  end

  # GET /filings/1/edit
  def edit
    @filing = Filing.find(params[:id])
  end

  # POST /filings
  # POST /filings.json
  def create
    @filing = Filing.new(params[:filing])

    respond_to do |format|
      if @filing.save
        format.html { redirect_to @filing, notice: 'Filing was successfully created.' }
        format.json { render json: @filing, status: :created, location: @filing }
      else
        format.html { render action: "new" }
        format.json { render json: @filing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filings/1
  # PUT /filings/1.json
  def update
    @filing = Filing.find(params[:id])

    respond_to do |format|
      if @filing.update_attributes(params[:filing])
        format.html { redirect_to @filing, notice: 'Filing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filings/1
  # DELETE /filings/1.json
  def destroy
    @filing = Filing.find(params[:id])
    @filing.destroy

    respond_to do |format|
      format.html { redirect_to filings_url }
      format.json { head :no_content }
    end
  end
end
