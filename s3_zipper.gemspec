# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "s3_zipper/version"

Gem::Specification.new do |spec|
  spec.name    = "s3_zipper"
  spec.version = S3Zipper::VERSION
  spec.authors = ["Capshare", "Nickolas Komarnitsky"]
  spec.email   = [""]

  spec.summary     = "Gem for zipping files in s3"
  spec.description = ""
  spec.homepage    = "https://github.com/capshareinc/s3zipper"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"]    = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/capshareinc/s3zipper"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.70.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "thor"
  spec.add_dependency "aws-sdk-s3", "~> 1"
  spec.add_dependency "concurrent-ruby", "~> 1.1"
  spec.add_dependency "ruby-progressbar", "~> 1"
  spec.add_dependency "rubyzip", ">= 1.0.0"
end
