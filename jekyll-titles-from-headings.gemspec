# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "jekyll-titles-from-headings/version"

Gem::Specification.new do |s|
  s.name          = "jekyll-titles-from-headings"
  s.version       = JekyllTitlesFromHeadings::VERSION
  s.authors       = ["Ben Balter"]
  s.email         = ["ben.balter@github.com"]
  s.homepage      = "https://github.com/benbalter/jekyll-titles-from-headings"
  s.summary       = "A Jekyll plugin to pull the page title from the first " \
                    "Markdown heading when none is specified."

  s.files         = `git ls-files lib *.md`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.license       = "MIT"

  s.add_dependency "jekyll", ">= 3.3", "< 5.0"
  s.add_development_dependency "kramdown-parser-gfm", "~> 1.0"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "rubocop", "~> 1.18"
  s.add_development_dependency "rubocop-jekyll", "~> 0.10"
  s.add_development_dependency("rubocop-performance", "~> 1.5")
  s.add_development_dependency("rubocop-rspec", "~> 2.0")
end
