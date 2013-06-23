module DocPagesHelper

  # First line of each result row
  # Show as much information about the source of the filing
  def result_header(page)
    data = []
    author = [nil]

    # If the filing was from an incarcerated person
    # we need to note that, along with the author's name
    # where it exists.
    if filer = page.section_filer
      if filer.incarcerated
        author.push("An Incarcerated Person")
      end
      unless filter.statecode.nil?
        author.push("in #{filer.statecode}")
      end
    end


    filing = page.filing
    # Try to avoid listing "Various" if we have better information
    if filing.author != "Various"
      author[0] = filing.author
    end

    unless (x = author.compact.join(' ')).empty?
      data.push(x)
    end

    # If all else has failed, fall back to avoided data
    if data.compact.blank?
      data = [filing.author || filing.applicant]
    end

    result = [filing.filing_type]

    unless (x = data.compact).blank?
      result.push('from')
      result.push(x.join(' '))
    end

    result.join(' ')
  end

  def search_result(doc_page)
    content_tag(:div, :class => 'result') do
        data = [content_tag(:div, link_to(result_header(doc_page), doc_page), :class => 'primary')]

        add_secondary = Proc.new do |label, value, format_date=false|
          unless value.blank?
            content = content_tag(:div ,:class => 'secondary') do
              content_tag(:span, label, :class => 'name') +
              content_tag(:span, format_date ? time_tag(value.to_date) : value, :class => 'value')
            end
            data.push(content)
          end
        end

        add_secondary.call("Page", doc_page.pagenumber)
        add_secondary.call("Law Firm", doc_page.filing.lawfirm)
        add_secondary.call("Applicant", doc_page.filing.applicant)
        add_secondary.call("Received", doc_page.filing.recv_date, true)
        add_secondary.call("Posted", doc_page.filing.posting_date, true)

        data.join("\n").html_safe
    end
  end
end
