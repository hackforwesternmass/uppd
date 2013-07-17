class DocumentTagsController < ApplicationController
  def by_dom_id_root
    doc_page = DocPage.first(:conditions => {:filing_doc_id => params[:filing_doc_id], :pagenumber => params[:pagenumber]})
    render json: doc_page.document_tags_attributes.inject({}) { |hash, tag| hash[tag["dom_id_root"]] = tag; hash }
  end

  def create
    ActiveRecord::Base.transaction do
      filing_doc = FilingDoc.find(params[:filing_doc_id])
      section = Section.create(params.slice('start_page', 'end_page').merge(:filing_doc_id => filing_doc.id, :fcc_num => filing_doc.fcc_num))
      document_tag = DocumentTag.create(:section_id => section.id, :tag_id => params[:tag_id])
      render_document_tag 
    end
  end

  def update
    ActiveRecord::Base.transaction do
      section_id, document_tag_id = params.values_at(:section_id, :document_tag_id)
      Section.update(section_id, params.slice(:start_page, :end_page))
      DocumentTag.update(document_tag_id, :section_id => section_id, :tag_id => params[:tag_id])
      render_document_tag
    end
  end

  def delete
     ActiveRecord::Base.transaction do
      unless params.values_at(:section_id, :document_tag_id).any?(&:blank?)
        Section.delete(params[:section_id])
        DocumentTag.delete(params[:document_tag_id])
        render_document_tag
      end
     end
  end

  protected
  def render_document_tag
    render json: DocPage.first(:conditions => {:filing_doc_id => params[:filing_doc_id], :pagenumber => params[:start_page]}).document_tags.find { |tag| tag.context == params[:context] }.extended_attributes
  end
end
