module DocPagesHelper

  # First line of each result row
  # Show as much information about the source of the filing
  def result_header(page)

    filing = page.filing

    data = [filing.filing_type, 'from']

    if filing.author.present?
      data.push(filing.author)
    else
      data.push(filing.applicant)
    end

    data.join(' ')
  end

  # Result block
  def search_result(doc_page)
    content_tag(:div, :class => 'result') do
        data = []

        data.push content_tag(:div, link_to(result_header(doc_page), page_path(doc_page, :search_path => @search_path)), :class => 'primary')

        data.push <<-EOS
        <div class="secondary">
        <span class="name">Page</span><span class="value">#{doc_page.pagenumber}</span> of <span class="value">#{doc_page.filing_doc.pagecount}</span>
        </div>
        EOS


        add_secondary = Proc.new do |label, value, format_date=false|
          unless value.blank?
            content = content_tag(:div ,:class => 'secondary') do
              content_tag(:span, label, :class => 'name') +
              content_tag(:span, format_date ? time_tag(value.to_date) : value, :class => 'value')
            end
            data.push(content)
          end
        end

        filing = doc_page.filing
        add_secondary.call("Law Firm", filing.lawfirm)
        add_secondary.call("Applicant", filing.applicant) if filing.author.to_s.downcase != filing.applicant.to_s.downcase 
        add_secondary.call("Received", filing.recv_date, true)
        add_secondary.call("Posted", filing.posting_date, true)

        data.join("\n").html_safe
    end
  end

  # url to individual page images -- extracted during the ocr process.
  def page_url(doc_page, pagenumber=nil)
    "http://ppi-extraction-image-production.s3.amazonaws.com/#{doc_page.filing_doc.fcc_num}/page-#{pagenumber || doc_page.pagenumber}.jpg"
  end

  # Header data when showing a single page
  def page_metadata(page)
    data = []
    add_data = Proc.new do |content|
        data.push(content_tag(:div, content))
    end
   
    filing = page.filing
    doc = page.filing_doc

    [["Filing: #{filing.fcc_num}", fcc_filing_url(filing)],
     ["Document: #{doc.fcc_num}", doc.url]].each do |args|
        add_data[link_to(*args)]
    end

    add_data["Pages: #{doc.pagecount}"] 

    %w(author lawfirm applicant).each do |name|
        if (value = filing.send(name)).present?
            add_data["#{name.titleize}: #{value}"]
        end
    end

    data.join("\n").html_safe
  end


  # left, right arrows
  def make_directional_slot(content, direction)

    html_options = {
      :id => "pager_#{direction}",
      :class => ["tiny button #{direction}"],
      :onclick => "pager.#{direction}()",
    }

    content_tag(:span, content, html_options)
  end


  # arrows and page numbers
  # generates html + javascript
  def page_navigation(page)

    data = []
    
    pagecount = page.filing_doc.pagecount

    data.push make_directional_slot("<", :previous) if pagecount > 1
    data.push 'Page', content_tag(:span, page.pagenumber, :id => "pagenumber"), 'of',  content_tag(:span, pagecount, :id => 'pagecount')
    data.push make_directional_slot(">", :next) if pagecount > 1

    data.push render(:partial => "doc_pages/pager", :formats => :js, :handlers => :erb,  :locals => { page: page })

    data.join("\n").html_safe
  end
end
