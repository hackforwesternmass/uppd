module ApplicationHelper
  def fcc_filing_url(filing)
    "http://apps.fcc.gov/ecfs/comment/view?id=#{filing.fcc_num}"
  end
end
