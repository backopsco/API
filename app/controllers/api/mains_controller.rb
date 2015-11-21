class Api::MainsController < ApplicationController
  layout 'docs'

  def show
    @page = Page.where(name: :main).first || Page.new
  end
end
