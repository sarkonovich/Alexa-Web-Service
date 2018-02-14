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

## Usage ##

The Alexa Web Service gem handles the JSON requests and responses that constitute an Alexa "Skill."
For general information on creating an Alexa skill as a web service, look here:
https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference#Introduction

Alexa will send your web service JSON in an HTTP POST request, like so:

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

#### Verify: Verify the Alexa request ####

The Alexa Web Service framework will automatically verify that the request comes from Amazon, as outlined [here](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-web-service)

The AlexaVerify class takes two parameters: the request body sent by the client, and the raw environment hash.
So if you're setting up a Sinatra server, you can verify the request like so:

````Ruby
# If the request body has been read, like in the Eight Ball example,
# you need to rewind it.
request.body.rewind

# Verify the request.
verified = AlexaWebService::Verify.new(request.env, request.body.read).verify_request
halt 400, "#{verified}" unless verified == "OK"
````

#### Request: Handling the request from Alexa ####

Create an instance of the AlexaRequest class to provide some convenience methods for handling the JSON request:

````Ruby
@echo_request = AlexaWebService::Request.new(request_json)

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


#### Response: Respond to Alexa requests ####

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
### Adding a  Directive ###
AlexaWebService supports directives: [hint and display directives](https://developer.amazon.com/docs/custom-skills/display-interface-reference.html) (for Alexa devices with screens), and [progresssive response](https://developer.amazon.com/docs/custom-skills/send-the-user-a-progressive-response.html). They work a little differently. 

*Display Directive*
Please see the Amazon docs. Display Directives are a bit involved.
First, create the directive:
````ruby
display = AlexaWebService::DisplayDirective.new(
  type: "Body Template Type", token: "Your Token", title: "Your Title"
  )
display.add_text(primary_text: "first text", secondary_text: "second_text", tertiary_text: "third text")
display.add_background_image("title", url)
display.add__image("title", url)
````
then, add it to your response:
````
response.add_directive(display.directive)
````
*Hint Directive*
````
hint = AlexaWebService::HintDirective.new("Buy low, sell high!")
response.add_directive(hint.directive)
````
*Progressive Response*
These are a bit different than other directives. They are not sent with your response, but are sent before. They take two parameters, the entire request object, and the text you'd like Alexa to speak.
````
progressive_response = AlexaWebService::ProgressiveResponse.new(request, "Hang on, looking up information.")
````
Then send it....
````
progressive_response.post
````


### Sending a Card ###

You can also [send a card](https://developer.amazon.com/docs/custom-skills/include-a-card-in-your-skills-response.html) to the Alexa app:
AlexaWebService supports four kinds of cards:
- Plain Text
- Image
- Linking
- Permissions

First, create a card: 
````
card = AlexaWebService::Card.new
````

Then add the card attributes you want (text, image, or permissions if sending a permissions card):
````Ruby
card.title = "My Alexa Card"
card.content "Formating is really limited to: \nline breaks"
card.small_image = "https://your_small_image_url.jpg"
card.large_image = "https://your_large_image_url.jpg"
````
Finally, add the card to your response, specifying the kind of card you created:
````
response.add_card(card.with_image)
````
other possibilities:
````
# text only
response.add_card(card.with_text)    

# permissions
response.add_card(card.with_permissions)
````
If you create a skill that uses [account linking](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/linking-an-alexa-user-with-a-user-in-your-system)
````
# linking
response.add_card(card.linking)
````
Finally, post your response

````
response.post
````


## Contributing

1. Fork it ( https://github.com/[my-github-username]/alexa_web_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

