module AlexaWebService
	class AlexaVerify

    def initialize(request_env, request_body)
      @timestamp = JSON.parse(request_body)["request"]["timestamp"]
      @url = request_env["HTTP_SIGNATURECERTCHAINURL"]
      @signature = request_env["HTTP_SIGNATURE"]
      @digest = OpenSSL::Digest::SHA1.new
    end

	  def valid_address?
	    valid_address = /^https:\/\/s3.amazonaws.com(:443)?\/echo.api\/.*?$/
	    @url == @url.match(valid_address)[0] rescue false
	  end

	  def valid_timestamp?
	    Time.now < DateTime.parse(@timestamp).to_time + 150 rescue false
	  end

	  def valid_certificate?(certificate)
	    certificate.subject.to_a.last.include?("echo-api.amazon.com") && 
	    Time.now.utc > certificate.not_before && 
	    Time.now.utc < certificate.not_after
	  end

	  def get_certificate
	  	begin
  			OpenSSL::X509::Certificate.new HTTParty.get(@url)
  		rescue TypeError
  			"Bad Request"
  		rescue OpenSSL::SSL::SSLError
  			"Bad Request"
  		end
  	end

	  def check_signature(certificate)
      certificate.public_key.verify(@digest, Base64.decode64(@signature), @data) rescue false
    end

    def verify_request

	    if valid_address? && valid_timestamp?
	    	@certificate = get_certificate
	    else
	    	"Bad Request"
	    end

	    if valid_certificate?(@certificate)
	    	@verify = check_signature(@certificate)
	    else
	    	"Invalid Certificate"
	    end

	    if @verify
	    	"OK"
	    else
	    	"Invalid Signature"
	    end
	  end
	end
end



