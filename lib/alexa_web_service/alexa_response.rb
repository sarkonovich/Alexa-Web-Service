require_relative './show_response.rb'
module AlexaWebService
	class Response < ShowResponse
    attr_accessor :session_attributes, :spoken_response, :card_title, :card_content, :reprompt_text, :end_session, :speech_type, :text_type, :directives
    def initialize (session_attributes: {}, spoken_response: nil, card_title: nil, card_content: nil, reprompt_text: nil, speech_type: "PlainText", text_type: "text", end_session: nil, directives: [])
      @session_attributes = session_attributes
      @speech_type = speech_type
      @spoken_response = spoken_response
      @card_title = card_title
      @card_content = card_content
      @reprompt_text = reprompt_text
      @text_type = text_type
      @end_session = end_session
      @directives = directives
    end

    def add_attribute(key, value)
      @session_attributes.merge!(key => value)
    end

    def append_attribute(key, value)
      @session_attributes[key] << value if @session_attributes[key] != nil
    end

    def add_show_template(type: "BodyTemplate1", token: "", back_button: "VISIBLE", background_image: {}, title: "", image: {})
      self.directives = ShowResponse.new(
        type: type, 
        token: token,  
        back_button: back_button, 
        background_image: background_image,
        title: title,
        image: image).directives
    end

		def parse_output_speech(reprompt = false)
			if !ssml_response
				{
					"type" => speech_type,
					"text" => reprompt ? reprompt_text : spoken_response
				}
			else
				{
					"type" => "SSML",
					"ssml" => ssml_response
				}
			end
		end

		def parse_output_speech(reprompt = false)
			if !ssml_response
				{
					"type" => speech_type,
					"text" => reprompt ? reprompt_text : spoken_response
				}
			else
				{
					"type" => "SSML",
					"ssml" => ssml_response
				}
			end
		end

		def with_card
				{
				  "version" => "1.0",
				  "sessionAttributes" =>
				    @session_attributes,
					"response" => {
					  "outputSpeech" => parse_output_speech,
					  "card" => {
					    "type" => "Simple",
					    "title" => card_title,
					    "content" => card_content
					  },
				  "reprompt" => {
				    "outputSpeech" => parse_output_speech(true)
				  },
				  "shouldEndSession" => end_session
				}
			}
		end

		def link_card
			self.with_card.tap { |hs| hs["response"]["card"] = {"type" => "LinkAccount"} }
		end

		def without_card
			self.with_card.tap { |hs| hs["response"].delete("card") }
		end
	end
end
