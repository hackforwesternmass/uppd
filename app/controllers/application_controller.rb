class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  def index

    context_fields = Tag.contexts_to_var
    date_metadata = Filing.date_metadata

    # period and default value
    date_periods =  {
                      year: Proc.new { |date| date.year },
                      month: 1,
                      day: 1
                    }

    # Since all operations occur with the GET method, this is the most reliable
    # way to determine whether a search should be run
    basic_search = params[:search].present?

    # NB: ruby 1.9.3p0 fails on this block when || is written as or
    # doubtlessly a precedence error, though I fail to see what tree 
    # derives
    advanced_search = ([:proceeding_id] + context_fields).any? do |name|
      params[name.to_s].present?
    end || date_metadata.any? do |entry|
      date_periods.keys.any? do |period|
        params[entry[:name].to_s][period.to_s].present? rescue false
      end
    end

    date_params = {} 

    if basic_search or advanced_search 
      @search = DocPage.solr_search do

        if basic_search
          DocPage.parse_search(params[:search]).each do |elt|
            if elt[:phrase]
              #TODO - cannot negate keyword searches - elt[:negate]
              fulltext elt[:phrase], :fields => elt[:keyword] || :pagetext
            end
          end
        end


        all_of do
          unless params[:proceeding_id].blank?
            with :proceeding_id, params[:proceeding_id]
          end

          context_fields.each do |context|
            unless params[context].blank?
              with :tag_id, params[context]
            end
          end

          date_metadata.each do |entry|
            ymd = date_periods.keys.inject({}) { |hash, period| hash[period] = params[entry[:name]][period]; hash }
            
            if ymd.values.any?(&:present?)

              date = Date.today

              # ensure valid parameters for Date.change!
              date_periods.each do |name, default|
                if ymd[name].blank? 
                  ymd[name] = default.is_a?(Proc) ? default.call(date) : default
                end
                ymd[name] = ymd[name].to_i
              end

              date = date.change(ymd)

              # save for use in view...
              # can't assign to instance method inside a block.
              # use variable instead. FWIW, I think this is a nasty workaround!
              date_params[entry[:name]] = date

              with(:filing_date).send(entry[:search_op], date)
            end
          end
        end

        paginate :page => params[:page] || 1, :per_page => 15
      end

      
      @date_params = date_params

      # show advanced controls in search results if they contributed...
      @advanced_state = advanced_search ? 'visible' : nil

      @hits = @search.hits
      @doc_pages = @search.results
      @search_path = request.original_fullpath.to_param
    end

    respond_to do |format|
      format.html 
      format.json { render json: @doc_pages }
    end
  end
end
