# AlexaWebService

Framework for building an Alexa skill. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alexa_web_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alexa_web_service

## Usage

The Alexa Web Service gem handles the JSON requests and responses that constitute an Alexa "Skill."
For general information on creating an Alexa skill as a web service, look here:
https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#Introduction

Alexa will send your web service (aka your "skill") JSON in an HTTP POST request, like so:

````Ruby
{
  "session": {
    "sessionId": "SessionId.abc12d34-12ab-1abc-111-a12c3456d7ef9",
    "application": {
      "applicationId": "amzn1.echo-sdk-ams.app.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    },å
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

####AlexaVerify: Verify the Alexa request####

The Alexa Web Service framework will automatically verify that the request comes from Amazon, as outlined [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-web-service)

The AlexaVerify class takes two parameters: the request body sent by the client, and the raw environment hash.
So if you're setting up a Sinatra server, you can verify the request like so:

````Ruby
# If the request body has been read, like in the Eight Ball example,
# you need to rewind it.
request.body.rewind

# Verify the request.
AlexaWebService::AlexaVerify.new(request.env, request.body.read)
````

####AlexaRequest: Handling the request from Alexa.####

Create an instance of the AlexaRequest class to provide some convenience methods for handling the JSON request:

````Ruby
@echo_request = AlexaWebService::AlexaRequest.new(request_json)

@echo_request.intent_name
@echo_request.slots
@echo_request.slots.myslot
@echo_request.launch_request?
@echo_request.intent_request?
@echo_request.session_ended_request?
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

````response = AlexaWebService::Response.new````

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
response = AlexaWebService::Response.new

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





## Contributing

1. Fork it ( https://github.com/[my-github-username]/alexa_web_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
