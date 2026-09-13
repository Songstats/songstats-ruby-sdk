# Changelog

All notable changes to this project are documented in this file.

## Unreleased

### Fixed

- Retry only GET requests; ambiguous write failures are surfaced after one attempt.
- Disable Net::HTTP automatic retries so the SDK retry budget is enforced, and apply the configured timeout to socket writes.

## [0.2.1] - 2026-06-14

### Changed

- Updated the default Enterprise API host from `data.songstats.com` to `api.songstats.com`.

## [0.2.0] - 2026-02-19

### Changed

- Removed `charts` resource client from the SDK surface
- Removed `stations` resource client from the SDK surface

## [0.1.0] - 2026-02-19

### Added

- Initial standalone Ruby SDK repo for Songstats Enterprise API (`/enterprise/v1`)
- Full resource coverage:
  - `info`
  - `tracks`
  - `artists`
  - `collaborators`
  - `labels`
  - `charts`
  - `stations`
- Shared HTTP client with:
  - `apikey` header auth
  - JSON response decoding
  - retry/backoff on transport errors and retryable status codes
- Structured exception types for API and transport failures
- Route coverage audit doc mapping Rails routes to SDK methods
- Test suite covering route mapping, header auth, validation, and error handling
- GitHub Actions CI workflow (`bundle exec rake test`)
- GitHub Actions release workflow for tag-based gem publishing (`v*`)
