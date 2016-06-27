require 'sinatra/base'
require 'json'
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
        @echo_request = AlexaWebService::AlexaRequest.new(JSON.parse(@data))
        @application_id = @echo_request.application_id
        

        # If the request body has been read, you need to rewind it.
        request.body.rewind
        AlexaWebService::AlexaVerify.new(request.env, request.body.read)
      end
    end
  end
end