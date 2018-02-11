

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
          
          # Creaste a progressive response...
          progressive_response = AlexaWebService::ProgressiveResponse.new(@echo_request, "Looking into the future")
          
          # Create a display directive for the Show or Spot
          display_template = AlexaWebService::DisplayDirective.new(type: "BodyTemplate2", token: "token", title: "Magic Eight Ball")
          display_template.add_image("eight_ball_image", "https://s3-us-west-2.amazonaws.com/alexa-magic-eight-ball-demo/eight_ball.jpg")
          display_template.add_text(primary_text: r.spoken_response)
          
          # Some Display Templates allow you to add hints
          hint = AlexaWebService::HintDirective.new("Never trust fortune tellers!")
          
          # Send the Progressive Response
          progressive_response.post

          # Add the directives to the response...
          r.add_directive(hint.directive)
          r.add_directive(display_template.directive)
          
          r.end_session = true
        
        elsif @echo_request.session_ended_request?
          r.end_session = true
        elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
          r.end_session = true
        end
        r.card_image_small = "https://s3-us-west-2.amazonaws.com/alexa-magic-eight-ball-demo/eight_ball.jpg"
        r.card_title = "Magic Eight Ball"
        r.card_content = "I never tell a lie"
        r.with_image_card.to_json
      end
    end
  end
  register EightBall
end