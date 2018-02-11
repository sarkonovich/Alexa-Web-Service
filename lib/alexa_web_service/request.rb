module AlexaWebService
  class Request
    attr_reader :intent_name, :slots, :timestamp, :request_type, :session_new, :user_id, :access_token, :application_id, :request_id, :api_access_token, :api_endpoint, :device_id, :response_hash
    attr_accessor :attributes
    alias :session_new? :session_new

    def initialize(response_hash)
      if response_hash["session"]["attributes"]
        @attributes   = response_hash["session"]["attributes"]
      else
        @attributes   = {}
      end
      @response_hash = response_hash
      @api_access_token = response_hash["context"]["System"]["apiAccessToken"]
      @api_endpoint = response_hash["context"]["System"]["apiEndpoint"]
      @device_id = response_hash["context"]["System"]["device"]["deviceId"]
      @request_id = response_hash["request"]["requestId"]
      @request_type     = response_hash["request"]["type"]
      @timestamp      = response_hash["request"]["timestamp"]
      @session_new    = response_hash["session"]["new"]
      @user_id      = response_hash["session"]["user"]["userId"]
      @access_token   = response_hash["session"]["user"]["accessToken"]
      @application_id   = response_hash["session"]["application"]["applicationId"]
      if response_hash["request"]["intent"]
        @intent_name  =  response_hash["request"]["intent"]["name"]
        @slots      = build_struct(response_hash["request"]["intent"]["slots"])
      end
    end

    def filled_slots
      @slots.select { |slot| slot != nil} rescue []
    end

    def intent_request?
      request_type == "IntentRequest"
    end

    def launch_request?
      request_type == "LaunchRequest"
    end

    def slot_hash
      if response_hash["request"]["intent"]
        response_hash["request"]["intent"]["slots"]
      end
    end

    def session_ended_request?
      request_type == "SessionEndedRequest"
    end

    private 
    def build_struct(hash)
      if hash.nil? || hash.empty?
        nil
      else
        slot_names = hash.keys.map {|k| k.to_sym.downcase }
        slot_values = hash.values.map { |v| v["value"] }
        Struct.new(*slot_names).new(*slot_values)
      end
    end
  end
end