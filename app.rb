require 'sinatra/base'
require 'json'
require './alexa_objects'
require './verify'
require './eight_ball'



module Sinatra
  class MyApp < Sinatra::Base
    
    set :protection, :except => [:json_csrf]
    register Sinatra::EightBall
    helpers  Sinatra::AlexaVerify
    
    # You might need the following if you are implementing account linking.
    # helpers Sinatra::Cookies
    # enable :inline_templates
    # enable :sessions

    before do
      if request.request_method == "POST"
        content_type :json, 'charset' => 'utf-8'
        
        @data = request.body.read
        params.merge!(JSON.parse(@data))
        @echo_request = AlexaObjects::AlexaRequest.new(JSON.parse(@data))
        @application_id = @echo_request.application_id
        
        # Necessary for skill certification:
        # verify_request
      end
    end
    run!
  end
end