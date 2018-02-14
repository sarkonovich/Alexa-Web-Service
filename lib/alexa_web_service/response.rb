module AlexaWebService
  class Response
    attr_accessor :session_attributes, :spoken_response, :card, 
                  :reprompt_text, :end_session, :speech_type, 
                  :text_type, :directives
    
    def initialize
      @session_attributes = {}
      @speech_type        = "PlainText"
      @spoken_response    = ''
      @reprompt_text      = ''
      @text_type          = "text"
      @end_session        = 'true'
      @card               = nil
      @directives         = []
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

    def add_card(card)
      self.card = card
    end

    def post
      {
        "version": "1.0",
        "sessionAttributes": @session_attributes,  
        "response": {
          "outputSpeech": {
            "type": speech_type,
            "#{text_type}": spoken_response
          },
          "card": card,
          "reprompt": {
            "outputSpeech": {
              "type": speech_type,
              "text": reprompt_text
            }
          },
          "directives": @directives,
          "shouldEndSession": end_session
        }
      }.to_json
    end
  end
end