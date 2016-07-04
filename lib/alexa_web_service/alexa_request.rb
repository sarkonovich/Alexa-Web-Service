module AlexaWebService
	class AlexaRequest
		attr_reader :intent_name, :slots, :timestamp, :request_type, :session_new, :user_id, :access_token, :application_id
		attr_accessor :attributes
		alias :session_new? :session_new

		def initialize(response_hash)
			session = response_hash["session"]
      request = response_hash["request"]
      if session
        @attributes = session["attributes"] ? session["attributes"] : {}
        @user_id = session["user"]["userId"] if session["user"]
        @access_token = session["user"]["accessToken"] if session["user"]
        @application_id = session["application"]["applicationId"] if session["application"]
      end

      if request
        @request_type = request["type"]
        @timestamp = request["timestamp"]
        @session_new = request["new"]

        if request["intent"]
          @intent_name  =  request["intent"]["name"] if request["intent"]
          @slots      = build_struct(request["intent"]["slots"]) if request["intent"]
        end
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

		def session_ended_request?
			request_type == "SessionEndedRequest"
		end

		private	
		def build_struct(hash)
			unless hash.nil?
				slot_names = hash.keys.map {|k| k.to_sym.downcase }
				slot_values = hash.values.map { |v| v["value"] }
				Struct.new(*slot_names).new(*slot_values)
			end
		end
	end
end