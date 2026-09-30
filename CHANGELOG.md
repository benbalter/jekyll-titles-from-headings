# Changelog

## 0.5.7

Maintenance release: no runtime behavior changes.

### Infrastructure

- Releases are now published from GitHub Actions via RubyGems trusted
  publishing when a `vX.Y.Z` tag is pushed (#103)
- Declare explicit, least-privilege workflow permissions and remove stale
  repository configuration (#102)

## 0.5.6

### Fixed

- With `strip_title: true`, the title is now also stripped from excerpts of
  documents in collections other than `_posts` (#81, #82, @staticintlucas)

### Documentation

- Add a gemspec description and RubyGems metadata (homepage, source code,
  bug tracker, and changelog links), and lead the README with the same
  one-line description (#99)

## 0.5.5

### Bug fixes

- Strip ATX closing hashes, so `# Title ##` produces the title `Title` (#97)

### Internal

- Use `Liquid::Context` instead of a custom context class (#97)

### Dependencies

- Declare `required_ruby_version >= 3.0` (#89)

### Infrastructure

- Bump `github/codeql-action` (#90, #94)

## 0.5.4

### Bug fixes

- Only strip the title from a document's excerpt when that document actually
  generates an excerpt, avoiding needless excerpt creation (#63)

### Infrastructure

- Modernize CI — test Ruby 3.3 & 4.0 against Jekyll 3.x & 4.x, and fix the
  build under rubocop-rspec 3.0 (#87)
- Bump rubocop-rspec to `~> 3.0` (#83)
- Enable Dependabot for GitHub Actions; bump `actions/checkout` and
  `github/codeql-action` (#84, #85, #86)
- Add `kramdown-parser-gfm` as a dev dependency
- Add CodeQL analysis workflow
