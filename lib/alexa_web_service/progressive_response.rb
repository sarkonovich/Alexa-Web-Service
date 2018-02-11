require 'httparty'

module AlexaWebService
  class ProgressiveResponse
    attr_accessor :speech
    attr_reader :directive, :request
    
    def initialize(request, speech)
      @request = request
      @speech = speech  
      @directive = {
        "header"=> { 
          "requestId"=>request.request_id
        },
        "directive"=> { 
          "type"=>"VoicePlayer.Speak",
          "speech"=>speech
        }
      }
    end

    def url
      if request.api_endpoint
        request.api_endpoint + "/v1/directives"
      end
    end

    def headers
      {
        "Authorization" => "Bearer #{request.api_access_token}",
        "Content-Type" => "application/json"
      }
    end
    
    def post
      HTTParty.post(url, :headers=>headers, :body=>self.directive.to_json)
    end
  end
end
