# Changelog

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
