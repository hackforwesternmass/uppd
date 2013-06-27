class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  def index

    context_fields = Tag.contexts_to_var
    date_metadata = Filing.date_metadata

    # All search fields must be listed here!
    # Since all operations occur with the GET method, this is the most reliable
    # way to determine whether a search should be run
    all_fields  = [:search, :proceeding_id] + context_fields + date_metadata.map { |entry| entry[:name] }

    date_params = {} 
    advanced_state = nil

    if all_fields.any? { |name| params[name].present? }
      @search = DocPage.solr_search do
        DocPage.parse_search(params[:search]).each do |elt|
          if elt[:phrase]
            #TODO - cannot negate keyword searches - elt[:negate]
            fulltext elt[:phrase], :fields => elt[:keyword] || :pagetext
          end
        end

        unless all_fields.count { |name| name != :search }.zero?
            advanced_state = "visible"
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
            ymd = %w(year month day).inject({}) { |hash, period| hash[period.to_sym] = params[entry[:name]][period]; hash }
            
            if ymd.values.any?(&:present?)

              date = Date.today

              ymd[:year] = ymd[:year].blank? ? date.year : ymd[:year].to_i
              ymd[:month] = ymd[:month].blank? ? 1 : ymd[:month].to_i 
              ymd[:day] = ymd[:day].blank? ? 1 : ymd[:day].to_i

              date = date.change(ymd)

              date_params[entry[:name]] = date

              with(:filing_date).send(entry[:search_op], date)
            end
          end
        end

        paginate :page => params[:page] || 1, :per_page => 15

      end

      @date_params = date_params
      @advanced_state = advanced_state
      @hits = @search.hits
      @doc_pages = @search.results

    end

    respond_to do |format|
      format.html 
      format.json { render json: @doc_pages }
    end
  end
end
