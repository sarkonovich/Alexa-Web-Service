module Sinatra
	module AlexaObjects
		class Response
			attr_accessor :session_attributes, :spoken_response, :card_title, :card_content, :reprompt_text, :end_session, :speech_type, :text_type
			def initialize(params={})
	      @session_attributes = params[:session_attributes] || {}
	      @speech_type = params[:speech_type] || "PlainText"
	      @spoken_response = params[:spoken_response] || nil
	      @card_title = params[:card_title] || nil
	      @card_content = params[:card_content] || nil
	      @reprompt_text = params[:reprompt_text] || nil
	      @text_type = params[:text_type] || "text"
	      @end_session = params[:end_session] || true
	    end

			def add_attribute(key, value)
				@session_attributes.merge!(key => value)
			end

			def append_attribute(key, value)
				@session_attributes[key] << value if @session_attributes[key] != nil
			end

			def with_card
					{
					  "version" => "1.0",
					  "sessionAttributes" =>
					    @session_attributes, 	
						"response" => {
						  "outputSpeech" => {
						    "type" => speech_type,
						    "#{text_type}" => spoken_response
						  },
						  "card" => {
						    "type" => "Simple",
						    "title" => card_title,
						    "content" => card_content
						  },
					  "reprompt" => {
					    "outputSpeech" => {
					      "type" => speech_type,
					      "text" => reprompt_text
					    }
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
end