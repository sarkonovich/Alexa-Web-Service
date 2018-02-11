# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alexa_web_service/version"

Gem::Specification.new do |spec|
  spec.name          = "alexa_web_service"
  spec.version       = AlexaWebService::VERSION
  spec.authors       = ["sarkonovich"]
  spec.email         = ["arkonovs @ reed. edu"]

  spec.summary       = "A framework to handle the JSON request/responses for an Alexa skill"
  spec.description   = "A framework to handle and verify the JSON request/responses for an Alexa skill"
  spec.homepage      = "https://github.com/sarkonovich/Alexa-Web-Service"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "httparty", "~> 0.15.7"
  spec.add_development_dependency "json", '~> 2.1', '>= 2.1.0'
end
