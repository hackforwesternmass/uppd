class ProceedingsController < ApplicationController
  # GET /proceedings
  # GET /proceedings.json
  def index
    @proceedings = Proceeding.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proceedings }
    end
  end

  # GET /proceedings/1
  # GET /proceedings/1.json
  def show
    @proceeding = Proceeding.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proceeding }
    end
  end

  # GET /proceedings/new
  # GET /proceedings/new.json
  def new
    @proceeding = Proceeding.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proceeding }
    end
  end

  # GET /proceedings/1/edit
  def edit
    @proceeding = Proceeding.find(params[:id])
  end

  # POST /proceedings
  # POST /proceedings.json
  def create
    @proceeding = Proceeding.new(params[:proceeding])

    respond_to do |format|
      if @proceeding.save
        format.html { redirect_to @proceeding, notice: 'Proceeding was successfully created.' }
        format.json { render json: @proceeding, status: :created, location: @proceeding }
      else
        format.html { render action: "new" }
        format.json { render json: @proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proceedings/1
  # PUT /proceedings/1.json
  def update
    @proceeding = Proceeding.find(params[:id])

    respond_to do |format|
      if @proceeding.update_attributes(params[:proceeding])
        format.html { redirect_to @proceeding, notice: 'Proceeding was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proceedings/1
  # DELETE /proceedings/1.json
  def destroy
    @proceeding = Proceeding.find(params[:id])
    @proceeding.destroy

    respond_to do |format|
      format.html { redirect_to proceedings_url }
      format.json { head :no_content }
    end
  end
end
