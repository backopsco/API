class Admin::PagesController < ApplicationController

  # GET /admin/pages
  def index
    @pages = Page.select([:name, :id]).all
  end

  # GET /admin/pages/1
  def show
    @page = Page.find(params[:id])
  end

  # GET /admin/pages/new
  def new
    @page = Page.new
  end

  # GET /admin/pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /admin/pages
  def create
    @page = Page.new(admin_page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_pages_url, notice: 'Page was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/pages/1
  def update
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.update(admin_page_params)
        format.html { redirect_to admin_pages_url, notice: 'Page was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to admin_pages_url, notice: 'Page was successfully destroyed.' }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_page_params
      params.require(:page).permit(:name, :markup)
    end
end
