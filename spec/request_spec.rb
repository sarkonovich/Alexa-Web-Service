require 'alexa_web_service/request'
require_relative 'fixtures/alexa_request_hash'

RSpec.describe AlexaWebService::Request do
  describe '#request_hash' do
    it 'returns the entire request hash' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).request_hash).to eq ALEXA_REQUEST
    end
  end

  describe '#api_access_token' do 
    it 'returns the IntentName from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).api_access_token).to eq "apiaccesstokensareverylong"
    end
  end

  describe '#api_endpoint' do
    it 'returns the api endpoint from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).api_endpoint).to eq "https://api.amazonalexa.com"
    end
  end

  describe '#device_id' do
    it 'returns the device id from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).device_id).to eq "amzn1.ask.device.DEVICE_ID"
    end
  end

  describe '#request_id' do
    it 'returns the request id from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).request_id).to eq "amzn1.echo-api.request.alexa-request-id"
    end
  end

  describe '#timestamp' do
    it 'returns the timestamp from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).timestamp).to eq "2018-02-15T00:05:35Z"
    end
  end

  describe '#session_new?' do
    it 'returns boolean indicating whether the session is new' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).session_new?).to eq true
    end
  end

  describe '#user_id' do
    it 'returns the user id from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).user_id).to eq "amzn1.ask.account.USER_ID"
    end
  end

  describe '#access_token' do
    it 'returns the access token from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).access_token).to eq "rGsAxJcroFDmidz2SBsElw"
    end
  end

  describe '#application_id' do
    it 'returns the application id from the request' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).application_id).to eq "amzn1.ask.skill.your-alexa-skill-application-id"
    end
  end

  describe '#slot_name' do
    it 'returns the the value of a named slot' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).slots.album).to eq "ray Charles"
    end
  end

  describe '#slots' do
    it 'returns a structure of slot names/values' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).slots.to_h).to eq :album => "ray Charles"
    end
  end

  describe '#attributes' do
    it 'returns an hash of session attributes from the request, if they exist' do
      stubbed_request = ALEXA_REQUEST
      expect(described_class.new(stubbed_request).attributes).to eq :session_attribute=>1
    end
  end
end