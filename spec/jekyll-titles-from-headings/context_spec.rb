# frozen_string_literal: true

RSpec.describe JekyllTitlesFromHeadings::Context do
  let(:site) { fixture_site("site") }
  subject { described_class.new(site) }

  it "returns the site" do
    expect(subject.site).to be_a(Jekyll::Site)
  end

  it "returns the registers" do
    expect(subject.registers).to be_a(Hash)
    expect(subject.registers).to have_key(:site)
    expect(subject.registers[:site]).to be_a(Jekyll::Site)
  end
end
