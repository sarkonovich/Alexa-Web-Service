# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alexa_web_service/version'

Gem::Specification.new do |spec|
  spec.name          = "alexa_web_service"
  spec.version       = AlexaWebService::VERSION
  spec.authors       = ["sarkonovich"]
  spec.email         = ["arkonovs @ reed. edu"]

  spec.summary       = "A framework to handle the JSON request/responses for an Alexa skill"
  spec.description   = "A framework to handle and verify the JSON request/responses for an Alexa skill"
  spec.homepage      = "https://github.com/sarkonovich/Alexa-Web-Service"

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = 'MIT'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'httparty', '~> 0.13.5'
  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.3'
  spec.required_ruby_version = '>= 2.0.0'
end
