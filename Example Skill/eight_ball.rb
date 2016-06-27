require 'sinatra/base'

ANSWER = ["absolutely!", "I doubt it", "If you want it badly enough",  "yes, the stars are aligned for you", "the future is uncertain", "no chance", "you control your own destiny"]

module Sinatra
  module EightBall
    def self.registered(app)
      app.post '/magic' do
        
        content_type :json

        # Uncomment this and include your skill id before submitting application for certification:
        # halt 400, "Invalid Application ID" unless @application_id == "your-skill-id"      
        
        r = AlexaWebService::Response.new

        if @echo_request.launch_request?
          r.end_session = false
          r.spoken_response = "I'm ready to tell your future. Ask me any yes no question."  
  
        elsif @echo_request.intent_name == "UserQuestion"
          r.spoken_response = "#{ANSWER.sample}"
          r.end_session = true
        
        # These are spelled out explicitly for demonstration purposes. Obviously, this could end with an "else" clause.
        # And, outside the conditional:  r.end_session ||= false  
        elsif @echo_request.session_ended_request?
          r.end_session = true
        elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
          r.end_session = true
        end
        r.without_card.to_json
      end
    end
  end
  register EightBall
end