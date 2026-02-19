require_relative "lib/songstats_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "songstats-ruby-sdk"
  spec.version = SongstatsSDK::VERSION
  spec.authors = ["Songstats"]
  spec.email = ["api@songstats.com"]

  spec.summary = "Ruby SDK for the Songstats Enterprise API."
  spec.description = "Typed Ruby client covering all /enterprise/v1 Songstats API routes."
  spec.homepage = "https://songstats.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/songstats/songstats-ruby-sdk"

  spec.files = Dir.chdir(__dir__) do
    Dir[
      "lib/**/*",
      "docs/**/*",
      "README.md",
      "CHANGELOG.md",
      "LICENSE"
    ]
  end

  spec.require_paths = ["lib"]
end
