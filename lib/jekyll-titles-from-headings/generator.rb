module JekyllTitlesFromHeadings
  class Generator < Jekyll::Generator
    attr_accessor :site

    TITLE_REGEX = %r!\A\s*\#{1,3}\s+(.*)\n$!
    CONVERTER_CLASS = Jekyll::Converters::Markdown

    # Regex to strip extra markup still present after markdownify
    # (footnotes at the moment).
    EXTRA_MARKUP_STRIP = %r!\[\^[^\]]*\]!

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
      !document.data["title"].nil?
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
      return unless matches
      html = markdown_converter.convert(matches[1]).rstrip
      title = Liquid::Template.parse("{{ '#{html}' | strip_html }}").render
      # gsub() here strips any markup (notably footnotes) that was left
      # intact because it couldn't be resolved. A slower alternative would
      # be to convert the whole document.
      title.gsub(EXTRA_MARKUP_STRIP, "")
    rescue ArgumentError => e
      raise e unless e.to_s.start_with?("invalid byte sequence in UTF-8")
    end
  end
end
