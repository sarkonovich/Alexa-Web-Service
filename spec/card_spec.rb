require 'alexa_web_service/card'

RSpec.describe AlexaWebService::Card do
  subject(:card) { described_class.new }

  describe '#with_text' do
    it 'generates a blank Simple card' do
      expected_result = { 
        type: "Simple", 
        title: "", 
        content: "" 
      }

      expect(card.with_text).to eq expected_result
    end
  end

  describe '#with_image' do
    it 'generates a blank image card' do
      expected_result = {
        type: "Standard", 
        title: "", 
        text: "", 
        image: { 
          smallImageUrl: nil,
          largeImageUrl: nil
        }
      }

      expect(card.with_image).to eq expected_result
    end
  end

  describe '#title' do
    it 'adds a title to an existing card' do
      expected_result = { 
        type: "Simple", 
        title: "This is the title", 
        content: "" 
      }

      card.title = "This is the title"
      expect(card.with_text).to eq expected_result
    end
  end

  describe '#content' do
    it 'adds content to an existing card' do
      expected_result = { 
        type: "Simple", 
        title: "", 
        content: "This is the content" 
      }

      card.content = "This is the content"
      expect(card.with_text).to eq expected_result
    end
  end

  describe '#small_image' do
    it 'adds a small image to an existing card' do
      expected_result = {
        type: "Standard", 
        title: "", 
        text: "", 
        image: { 
          smallImageUrl: "https://image_url",
          largeImageUrl: nil
        }
      }

      card.small_image = "https://image_url"
      expect(card.with_image).to eq expected_result
    end
  end

  describe '#large_image' do
    it 'adds a large image to an existing card' do
      expected_result = {
        type: "Standard", 
        title: "", 
        text: "", 
        image: { 
          smallImageUrl: nil,
          largeImageUrl: "https://image_url"
        }
      }

      card.large_image = "https://image_url"
      expect(card.with_image).to eq expected_result
    end
  end

  describe '#with_permission' do
    it 'generates a permissions card' do
      expected_result = {
      "type": "AskForPermissionsConsent", "permissions": ["read::alexa:device:all:address"]
      }

      card.add_permission("read::alexa:device:all:address")
      expect(card.with_permission).to eq expected_result
    end
  end

  describe '#linking' do
    it 'generates a LinkAccount card' do
      expected_result = {
        type: "LinkAccount"
      }

      expect(card.linking).to eq expected_result
    end
  end
end