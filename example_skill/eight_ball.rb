

ANSWER = ["absolutely!", "I doubt it", "If you want it badly enough",  "yes, the stars are aligned for you", "the future is uncertain", "no chance", "you control your own destiny"]

module Sinatra
  module EightBall
    def self.registered(app)
      app.post '/magic' do
        
        content_type :json

        # Uncomment this and include your skill id before submitting application for certification:
        # halt 400, "Invalid Application ID" unless @application_id == "your-skill-id"      
        
        response = AlexaWebService::Response.new

        if @echo_request.launch_request?
          response.end_session = false
          response.spoken_response = "I'm ready to tell your future. Ask me any yes no question."  
  
        elsif @echo_request.intent_name == "UserQuestion"
          response.spoken_response = "#{ANSWER.sample}"
          
          # Create a progressive response...
          progressive_response = AlexaWebService::ProgressiveResponse.new(@echo_request, "Looking into the future")
          
          # Create a display directive for the Show or Spot
          display_template = AlexaWebService::DisplayDirective.new(type: "BodyTemplate2", token: "token", title: "Magic Eight Ball")
          display_template.add_image("eight_ball_image", "https://s3-us-west-2.amazonaws.com/alexa-magic-eight-ball-demo/eight_ball.jpg")
          display_template.add_text(primary_text: response.spoken_response)

          # Create a card. Here we create a card with an image.
          card = AlexaWebService::Card.new
          card.title = "Magic Eight Ball"
          card.content = "I never tell a lie"
          card.small_image = "https://s3-us-west-2.amazonaws.com/alexa-magic-eight-ball-demo/eight_ball.jpg"
          
          # Some Display Templates allow you to add hints
          hint = AlexaWebService::HintDirective.new("Never trust fortune tellers!")
          
          # Send the Progressive Response
          progressive_response.post

          # Add the directives to the response...
          response.add_directive(hint.directive)
          response.add_directive(display_template.directive)
          
          # ...and add the card
          response.add_card(card.with_image)
        
        elsif @echo_request.session_ended_request?
          response.end_session = true
        elsif @echo_request.intent_name == "AMAZON.StopIntent" ||  @echo_request.intent_name == "AMAZON.CancelIntent"
          response.end_session = true
        end

        response.post
      end
    end
  end
  register EightBall
end