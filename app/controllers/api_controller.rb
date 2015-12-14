class ApiController < ApplicationController
  layout 'docs'

  def show
    slug = params[:id].presence
    if slug
      @page = Page.where(name: slug).first || Page.new
    else
      redirect_to api_url(:main)
    end
  end
end
