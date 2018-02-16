require_relative 'fixtures/permission_request_hash'
require 'alexa_web_service/progressive_response.rb'

RSpec.describe AlexaWebService::ProgressiveResponse do
  let(:stub_request) do
    AlexaWebService::Request.new(ALEXA_REQUEST)
  end

  subject(:progressive_response) { described_class.new(stub_request, "Say this first") }
  
  describe '#directive' do
    it 'creates a directive object' do
      expected_response = {
        "header"=> { 
          "requestId"=>stub_request.request_id
        },
        "directive"=> { 
          "type"=>"VoicePlayer.Speak",
          "speech"=>"Say this first"
        }
      }

      expect(progressive_response.directive).to eq expected_response
    end
  end

  describe '#speech' do
    it 'takes a string to be spoken output' do
      expect(progressive_response.speech).to eq "Say this first"
    end
  end

  describe '#url' do
    it 'gets the url from the request' do
      expect(progressive_response.url).to eq "https://api.amazonalexa.com/v1/directives"
    end
  end

  describe '#headers' do
    it 'generates headers to be sent' do
      expected_response = {
        "Authorization" => "Bearer #{stub_request.api_access_token}",
        "Content-Type" => "application/json"
      }

      expect(progressive_response.headers).to eq expected_response
    end
  end

  describe '#post' do
    it 'sends an HTTP post request' do
      response = progressive_response.post
      expect(response.code).to eq 403
    end
  end
end
