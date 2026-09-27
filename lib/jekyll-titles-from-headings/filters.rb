# frozen_string_literal: true

module JekyllTitlesFromHeadings
  class Filters
    include Jekyll::Filters
    include Liquid::StandardFilters

    def initialize(site)
      @site    = site
      @context = Liquid::Context.new({}, {}, :site => site)
    end
  end
end
