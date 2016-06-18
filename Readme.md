The Alexa Web Service simply handles the JSON requests and responses that constitute an Alexa "Skill."
For general information on creating an Alexa skill as a web service, look here:
https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#Introduction



####AlexaRequest: Verify and parse the request from Alexa.####

Alexa will send your web service (aka your "skill") JSON in an HTTP POST request, like so:

````Ruby
{
  "session": {
    "sessionId": "SessionId.abc12d34-12ab-1abc-111-a12c3456d7ef9",
    "application": {
      "applicationId": "amzn1.echo-sdk-ams.app.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    },
    "attributes": {},
    "user": {
      "userId": "amzn1.account.AHHLP1234ABC5DEFG6HIJK7XLMN"
    },
    "new": true
  },
  "request": {
    "type": "LaunchRequest",
    "requestId": "EdwRequestId.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "timestamp": "2016-06-17T21:07:57Z",
    "locale": "en-US"
  },
  "version": "1.0"
}
````

The Alexa Web Service framework will automatically verify that the request comes from Amazon, and check the signature and timestamp of the request, as outlined [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-web-service) 

It will also automatically create an instance of the AlexaRequest class just to provide some convenience methods for handling the JSON request:

````Ruby
@echo_request.intent_name 
@echo_request.slots
@echo_request.slots.myslot
@echo_request.launch_request
@echo_request.intent_request
@echo_request.session_ended_request
@echo_request.session_new?
````

Your skill provides different responses (see next section) depending on the the type/name/slot values of the request: 

````Ruby
if @echo_request.launch_request
  # have alexa say hello
elsif @echo_request.intent_name == "InformationRequest"
  # ask use for what kind of information she wants
elsif @echo_request.slots.time
  # tell user the time
end
````

(Take a look at eight_ball.rb for some further examples.)




####AlexaResponse:  Respond to Alexa requests.####

The AlexaResponse class generates the proper JSON to make Alexa responses.

Create a new response object:

````response = AlexaObjects::Response.new````

Then, define the response attributes:

````Ruby
response.end_session = true
response.spoken_response = "This is what Alexa will say to you"
response.reprompt_text = "This is what she'll say if she doesn't hear your response the first time."
````

You can then send the response back to Alexa with the following command:


````Ruby
response.without_card.to_json
````

So, putting the AlexaRequest and AlexaResponse together:

````Ruby
response = AlexaObjects::Response.new

if @echo_request.launch_request
  response.spoken_response = "Hello user"
  response.end_session = true
end

response.without_card.to_json
````
  



You can use [SSML](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/speech-synthesis-markup-language-ssml-reference):

````Ruby
response.speech_type = "SSML"
response.text_type = "ssml"
response.spoken_response = "<speak>Here is a word spelled out: <say-as interpret-as="spell-out">hello</say-as></speak>"
````

Alexa uses a "session attribute" to persist data within a session. (It's the empty "attributes" hash in the sample JSON request above.) The #add_attribute adds key:value pairs to that attributes hash.



````Ruby
response.add_attribute("favorite_color", "blue" )
````

You can also send text card to the Alexa app:

````Ruby
response.card_title = "My Alexa Card"
response.card_content "Formating is really limited to: \nline breaks"
````

When sending a card along with the spoken response use:

````
response.with_card.to_json
````

If you create a skill that uses [account linking](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/linking-an-alexa-user-with-a-user-in-your-system), you'll need to send a linking card:

````
response.link_card.to_json
````



