require 'sinatra/base'
require 'alexa_web_service'
require './eight_ball'

module Sinatra
  class MyApp < Sinatra::Base
    
    set :protection, :except => [:json_csrf]
    register Sinatra::EightBall
    
    # You might need the following if you are implementing account linking.
    # helpers Sinatra::Cookies
    # enable :inline_templates
    # enable :sessions

    before do
      if request.request_method == "POST"
        content_type :json, 'charset' => 'utf-8'
        
        @data = request.body.read
        begin
          params.merge!(JSON.parse(@data))
        rescue JSON::ParserError
          halt 400, "Bad Request"
        end
        
        params.merge!(JSON.parse(@data))
        
        # The request object.
        @echo_request = AlexaWebService::Request.new(JSON.parse(@data))
        
        # Boolean: does the Alexa Device handling the response have a screen? (Needed for AlexaWebService::DisplayDirective support)
        $display_support = JSON.parse(@data)["context"]["System"]["device"]["supportedInterfaces"]["Display"].any? rescue false
        
        # This can be used in your skill as additional verification that the request is coming from the right place
        @application_id = @echo_request.application_id
        
        # If the request body has been read, you need to rewind it.
        request.body.rewind
        AlexaWebService::Verify.new(request.env, request.body.read)
      end
    end
    run!
  end
end