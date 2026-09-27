# frozen_string_literal: true

RSpec.describe JekyllTitlesFromHeadings::Filters do
  subject { described_class.new(site) }

  let(:site) { fixture_site("site") }

  it "exposes the site to Jekyll's filters through a Liquid context" do
    context = subject.instance_variable_get(:@context)
    expect(context).to be_a(Liquid::Context)
    expect(context.registers[:site]).to eql(site)
  end

  it "markdownifies" do
    html = subject.markdownify("# test")
    expect(html).to eql("<h1 id=\"test\">test</h1>\n")
  end

  it "strips html" do
    string = subject.strip_html("<h1>test</h1>")
    expect(string).to eql("test")
  end

  it "normalizes whitespace" do
    string = subject.normalize_whitespace("test    test")
    expect(string).to eql("test test")
  end
end
