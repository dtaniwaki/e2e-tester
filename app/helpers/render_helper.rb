module RenderHelper
  def markdown(text, options = {})
    return nil if text.nil?

    options = options.reverse_merge(
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: '_blank' },
      space_after_headers: true,
      fenced_code_blocks: true
    )

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety
  end
end
