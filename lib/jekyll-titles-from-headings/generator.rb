module JekyllTitlesFromHeadings
  class Generator < Jekyll::Generator
    attr_accessor :site

    TITLE_REGEX = %r!^\#{1,3} (.*)\n$!
    CONVERTER_CLASS = Jekyll::Converters::Markdown

    safe true
    priority :lowest

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      site.pages.each do |document|
        next unless should_add_title?(document)
        document.data["title"] = title_for(document)
      end
    end

    def should_add_title?(document)
      markdown?(document) && !title?(document)
    end

    def title?(document)
      !document.data["title"].to_s.empty?
    end

    def markdown?(document)
      markdown_converter.matches(document.extname)
    end

    def markdown_converter
      @markdown_converter ||= site.find_converter_instance(CONVERTER_CLASS)
    end

    def title_for(document)
      return document.data["title"] if title?(document)
      matches = document.content.match(TITLE_REGEX)
      matches[1] if matches
    end
  end
end
