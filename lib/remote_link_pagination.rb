# frozen_string_literal: true

module RemoteLinkPagination
  class LinkRenderer < BootstrapPagination::Rails
    def link(text, target, attributes = {})
      attributes['data-remote'] = true
      super
    end

    def gap
      tag :li, tag(:span, '&hellip;&hearts;', class: 'gap'), 'data-go-to-page': true
    end
  end
end
