class Page < ActiveRecord::Base

  def html
    return @markdown_html if @markdown_html
    @markdown_html = markdown.render(markup || '*nothing* to Render')
  end

  private

  def markdown
    markdown = Redcarpet::Markdown.new(renderer,
                  fenced_code_blocks: true,
                  smartypants: true,
                  disable_indented_code_blocks: true,
                  prettify: true,
                  tables: true,
                  no_intra_emphasis: true
               )
  end

  def renderer
    @renderer ||= HTMLwithRouge.new(
                    fenced_code_blocks: true,
                    smartypants: true,
                    disable_indented_code_blocks: true,
                    prettify: true,
                    with_toc_data: true,
                    no_intra_emphasis: true
                  )
  end
end
