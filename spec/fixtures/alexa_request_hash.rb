ALEXA_REQUEST = {
 "version"=>"1.0",
 "session"=>
  {"new"=>true,
   "sessionId"=>"amzn1.echo-api.session.c7b426bf-d3fa-422c-9eab-a815629d4edd",
   "application"=>{"applicationId"=>"amzn1.ask.skill.your-alexa-skill-application-id"},
   "attributes"=> {
      "session_attribute": 1
    },
   "user"=>
    {"userId"=>
      "amzn1.ask.account.USER_ID",
     "accessToken"=>"rGsAxJcroFDmidz2SBsElw"}},
 "context"=>
  {"AudioPlayer"=>{"playerActivity"=>"IDLE"},
   "Display"=>{"token"=>"token"},
   "System"=>
    {"application"=>{"applicationId"=>"amzn1.ask.skill.your-alexa-skill-application-id"},
     "user"=>
      {"userId"=>
        "amzn1.ask.account.USER_ID",
       "accessToken"=>"rGsAxJcroFDmidz2SBsElw"},
     "device"=>
      {"deviceId"=>"amzn1.ask.device.DEVICE_ID",
       "supportedInterfaces"=>{"AudioPlayer"=>{}, "Display"=>{"templateVersion"=>"1.0", "markupVersion"=>"1.0"}}},
     "apiEndpoint"=>"https://api.amazonalexa.com",
     "apiAccessToken"=>
      "apiaccesstokensareverylong"}},
 "request"=> {
    "type"=> "IntentRequest",
    "requestId"=> "amzn1.echo-api.request.alexa-request-id",
    "timestamp"=> "2018-02-15T00:05:35Z",
    "locale"=> "en-US",
    "intent"=> {
      "name"=> "ArtistName",
      "confirmationStatus"=> "NONE",
      "slots"=> {
        "Album"=> {
          "name"=> "Album",
          "value"=> "ray Charles",
          "resolutions"=> {
            "resolutionsPerAuthority"=> [
              {
                "authority"=> "amzn1.er-authority.echo-sdk.amzn1.echo-sdk-ams.app.letters-numbers.ALBUMS",
                "status"=> {
                  "code"=> "ER_SUCCESS_NO_MATCH"
                }
              }
            ]
          },
          "confirmationStatus"=> "NONE"
        }
      }
    }
  }
}