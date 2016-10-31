# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "titles-from-headings/version"

Gem::Specification.new do |s|
  s.name          = "titles-from-headings"
  s.version       = TitlesFromHeadings::VERSION
  s.authors       = ["Ben Balter"]
  s.email         = ["ben.balter@github.com"]
  s.homepage      = "https://github.com/benbalter/titles-from-headings"
  s.summary       = "A Jekyll plugin to pull page the title from fist Markdown heading when none is specified"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.license       = "MIT"

  s.add_dependency "jekyll", "~> 3.3"
  s.add_development_dependency "rubocop", "~> 0.43"
  s.add_development_dependency "rspec", "~> 3.5"
end
