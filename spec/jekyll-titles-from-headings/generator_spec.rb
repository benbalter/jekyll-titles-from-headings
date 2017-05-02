RSpec.describe JekyllTitlesFromHeadings::Generator do
  let(:site) { fixture_site("site") }
  let(:post) { site.posts.first }
  let(:page) { page_by_path(site, "page.md") }
  let(:page_with_title) { page_by_path(site, "page-with-title.md") }
  let(:page_with_md_title) { page_by_path(site, "page-with-md-title.md") }
  let(:html_page) { page_by_path(site, "html-page.html") }
  let(:page_with_h2) { page_by_path(site, "page-with-h2.md") }
  let(:page_with_h3) { page_by_path(site, "page-with-h3.md") }
  let(:page_with_empty_title) { page_by_path(site, "page-with-empty-title.md") }
  let(:page_with_content_before_title) do
    page_by_path(site, "page-with-content-before-title.md")
  end

  subject { described_class.new(site) }

  before(:each) do
    site.reset
    site.read
  end

  it "saves the site" do
    expect(subject.site).to eql(site)
  end

  context "detecting titles" do
    it "knows when a page has a title" do
      expect(subject.title?(page_with_title)).to eql(true)
    end

    it "knows when a page doesn't have a title" do
      expect(subject.title?(page)).to eql(false)
    end
  end

  context "detecting markdown" do
    it "knows when a page is markdown" do
      expect(subject.markdown?(page)).to eql(true)
    end

    it "knows when a page isn't markdown" do
      expect(subject.markdown?(html_page)).to eql(false)
    end

    it "knows the markdown converter" do
      expect(subject.markdown_converter).to be_a(Jekyll::Converters::Markdown)
    end
  end

  context "detecting when to add a title" do
    it "knows not to add a title for pages with titles" do
      expect(subject.should_add_title?(page_with_title)).to eql(false)
    end

    it "knows not to add a title for HTML pages" do
      expect(subject.should_add_title?(html_page)).to eql(false)
    end

    it "knows not add a title to non-HTML pages without titles" do
      expect(subject.should_add_title?(page)).to eql(true)
    end

    it "knows not add a title to pages with empty titles" do
      expect(subject.should_add_title?(page_with_empty_title)).to eql(false)
    end
  end

  context "extracting title" do
    it "pulls title with an H1" do
      expect(subject.title_for(page)).to eql("Just an H1")
    end

    it "pulls title with an H2" do
      expect(subject.title_for(page_with_h2)).to eql("Just a tab-separated H2")
    end

    it "pulls title with an H3" do
      expect(subject.title_for(page_with_h3)).to eql("Just an H3 with two spaces")
    end

    it "strips Markdown syntax" do
      expect(subject.title_for(page_with_md_title)).to eql("Just the title, no markup")
    end

    it "respects YAML titles" do
      expect(subject.title_for(page_with_title)).to eql("Page with title")
    end

    it "respects content before the title" do
      expect(subject.title_for(page_with_content_before_title)).to be_nil
    end
  end

  context "generating" do
    before { subject.generate(site) }

    it "sets titles for pages" do
      expect(page.data["title"]).to eql("Just an H1")
    end

    it "respect a document's auto-generated title" do
      expect(post.data["title"]).to eql("Test")
    end

    it "respects a document's YAML title" do
      expect(page_with_title.data["title"]).to eql("Page with title")
    end
  end
end
