class DocPage < ActiveRecord::Base

  attr_accessible :filing_doc_id, :pagenumber, :pagetext, :wordcount
  
  belongs_to :filing_doc

  has_one :filing, :through => :filing_doc
  has_one :proceeding, :through => :filing

  has_many :sections,
           :finder_sql => Proc.new {
            [<<-EOS, filing_doc_id, pagenumber]
            SELECT * FROM sections WHERE filing_doc_id = ? AND ? BETWEEN start_page AND end_page
            EOS
  }
  
  searchable do 
    text :pagetext

    [:author, :lawfirm, :applicant].each do |name|
      text name do
        filing.send(name)
      end
    end

    integer :proceeding_id do
      proceeding.id
    end

    integer :tag_id, :multiple => true do 
      sections.map(&:document_tags).flatten.map(&:tag_id)
    end

    date :filing_date do
      filing.recv_date
    end
  end

  #TODO -- This has been obsoleted by tags. remove after migration
  def section_filer
    section.section_filer rescue nil 
  end

  def self.parse_search(terms)
      results = []
      keywords = %w(author lawfirm applicant)
      pos = 0
      
      skip_space = Proc.new do
        while [' ', "\t", "\n", "\r"].include?(terms[pos])
          pos += 1
        end
      end

      while pos < terms.size 
        
        printf("%d %s\n", pos, terms[pos..-1])

        result = {}
        terms.strip!
        
        if terms[pos] == "-"
          result[:negate] = true
          pos += 1
        end
        skip_space.call()


        keywords.each do |keyword|
          if terms[pos..-1] =~ /^#{keyword}:/
            result[:keyword] = keyword
            pos += keyword.size + 1
          end
          skip_space.call()
        end


        if terms[pos] == '"'
            if terms[pos..-1] =~ /^"([^"]+|\\"+)"/
              result[:phrase] = $1
              pos += $1.size + 2
            else
              pos += 1  #ignore quote
            end
        end
        skip_space.call()


        unless result[:phrase]
          if terms[pos..-1] =~ /^(\S+)/
            result[:phrase] = $1
            pos += $1.size
          else
            result[:phrase] = terms[pos..-1]
            pos += terms.size
          end
        end

        results.push result
      end

      warn results
      return results
  end
end
