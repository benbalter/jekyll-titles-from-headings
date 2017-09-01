RSpec.describe JekyllTitlesFromHeadings::Generator do
  let(:config) { {} }
  let(:site) { fixture_site("site", config) }
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
  let(:page_with_setex_h1) { page_by_path(site, "page-with-setex-h1.md") }
  let(:page_with_setex_h2) { page_by_path(site, "page-with-setex-h2.md") }
  let(:page_with_no_empty_line_after_title) do
    page_by_path(site, "page-with-no-empty-line-after-title.md")
  end
  let(:page_with_strip_title_true) do
    page_by_path(site, "page-with-strip-title-true.md")
  end
  let(:page_with_strip_title_false) do
    page_by_path(site, "page-with-strip-title-false.md")
  end
  let(:post) { doc_by_path(site, "_posts/2016-01-01-test.md") }
  let(:post_wihtout_heading) do
    doc_by_path(site, "_posts/2016-01-01-test-2.md")
  end
  let(:item) { doc_by_path(site, "_items/some-item.md") }

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

    it "pulls title with a Setex-style H1" do
      expect(subject.title_for(page_with_setex_h1)).to eql("This is also an H1")
    end

    it "pulls title with a Setex-style H2" do
      expect(subject.title_for(page_with_setex_h2)).to eql(
        "An H2 that was started with a space"
      )
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

    it "does not require a blank line after the title" do
      expect(
        subject.title_for(page_with_no_empty_line_after_title)
      ).to eql("This is the title")
    end
  end

  context "generating" do
    before { subject.generate(site) }

    it "sets titles for pages" do
      expect(page.data["title"]).to eql("Just an H1")
    end

    it "respects a document's auto-generated title" do
      expect(post.data["title"]).to eql("Test")
    end

    it "respects a document's YAML title" do
      expect(page_with_title.data["title"]).to eql("Page with title")
    end

    it "does not strip the title when not enabled in the configuration" do
      expect(page.content.strip).to eql("# Just an H1\n\nBlah blah blah")
    end

    context "stripping titles" do
      context "a site with strip title enabled globally" do
        let(:config) { { "titles_from_headings" => { "strip_title" => true } } }

        it "strips the title when enabled in the configuration" do
          expect(page.content.strip).to eql("Blah blah blah")
        end

        it "keeps the title when disabled in the front matter" do
          expect(page_with_strip_title_false.content.strip).to eql(
            "# Just an H1\n\nBlah blah blah"
          )
        end
      end

      it "strips the title when enabled in the front matter" do
        expect(page_with_strip_title_true.content.strip).to eql("Blah blah blah")
      end

      it "keeps the title when disabled in the front matter" do
        expect(page_with_strip_title_false.content.strip).to eql(
          "# Just an H1\n\nBlah blah blah"
        )
      end
    end

    context "collections" do
      let(:config) do
        {
          "titles_from_headings" => {
            "collections" => true,
          },
          "collections"          => {
            "items" => {
              "permalink" => "/items/:name/",
              "output"    => true,
            },
          },
        }
      end

      it "no longer respects auto-generated titles when collections is true" do
        expect(post.data["title"]).to_not eql("Test")
      end

      it "overrides a document's title with its heading" do
        expect(post.data["title"]).to eql("Some post")
      end

      it "will fall back on the auto-generated title if it can't find a heading" do
        expect(post_wihtout_heading.data["title"]).to eql("Test 2")
      end

      it "works with arbitrary items in collections" do
        expect(item.data["title"]).to eql("Some item")
      end
    end

    context "collections + strip_title" do
      let(:config) do
        {
          "titles_from_headings" => {
            "strip_title" => true,
            "collections" => true,
          },
        }
      end

      it "infers the title and strips it from the content" do
        expect(post.data["title"]).to eql("Some post")
        expect(post.content.strip).to eql("Blah blah blah")
      end
    end
  end

  context "when disabled" do
    let(:overrides) { { "titles_from_headings" => { "disabled" => true } } }

    it "sets titles for pages" do
      subject.generate(site)
      expect(page.data["title"]).to_not eql("Just an H1")
    end
  end

  context "when explicitly enabled" do
    let(:overrides) { { "titles_from_headings" => { "disabled" => false } } }

    it "sets titles for pages" do
      subject.generate(site)
      expect(page.data["title"]).to eql("Just an H1")
    end
  end
end
