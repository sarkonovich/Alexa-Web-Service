module AlexaWebService
  class Response
    attr_accessor :session_attributes, :spoken_response, :card_title, :card_content, :card_image_small, :card_image_large, :reprompt_text, :end_session, :speech_type, :text_type, :directives
    def initialize (
                      session_attributes: {}, spoken_response: nil, 
                      card_title: nil, card_content: nil, card_image_small: nil, card_image_large: nil, 
                      reprompt_text: nil, speech_type: "PlainText", 
                      text_type: "text", end_session: nil, directives: []
                    )
      @session_attributes = session_attributes
      @speech_type = speech_type
      @spoken_response = spoken_response
      @card_title = card_title
      @card_content = card_content
      @card_image_small = card_image_small
      @card_image_large = card_image_large
      @reprompt_text = reprompt_text
      @text_type = text_type
      @end_session = end_session
      @directives = directives
    end

    def add_attribute(key, value)
      @session_attributes.merge!(key => value)
    end

    def delete_attribute(key)
      @session_attributes.delete(key)
    end

    def append_attribute(key, value)
      @session_attributes[key] << value if @session_attributes[key] != nil
    end

    def add_directive(directive)
      self.directives << directive if $display_support == true
    end

    def with_card
        {
          "version": "1.0",
          "sessionAttributes":
            @session_attributes,  
          "response": {
            "outputSpeech": {
              "type": speech_type,
              "#{text_type}": spoken_response
            },
            "card": {
              "type": "Simple",
              "title": card_title,
              "content": card_content
            },
          "reprompt": {
            "outputSpeech": {
              "type": speech_type,
              "text": reprompt_text
            }
          },
          "directives": @directives,
          "shouldEndSession": end_session
        }
      }
    end

    def with_image_card
      image_blob = {
        "type": "Standard",
        "title": card_title,
        "text": card_content,
        "image": {
          "smallImageUrl": card_image_small,
          "largeImageUrl": card_image_large
          }
        }
      self.with_card.tap { |hs| hs[:response][:card] = image_blob }
    end

    def link_card
      self.with_card.tap { |hs| hs[:response][:card] = {"type": "LinkAccount"} }
    end

    # Will only return permissions requested in skill configuration
    # Possible values for permissions:
    # write for notifications:  "write::alexa:devices:all:notifications:standard"
    # read for full address: "read::alexa:device:all:address"
    # read for restricted address: "read::alexa:device:all:address:country_and_postal_code"
    def permissions_card(permissions)  
      self.with_card.tap do |hs| 
        hs[:response][:card] = {
          "type": "AskForPermissionsConsent", "permissions": [permissions]
        }
      end
    end

    def without_card
      self.with_card.tap { |hs| hs[:response].delete(:card) }
    end
  end
end