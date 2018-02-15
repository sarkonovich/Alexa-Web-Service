require 'alexa_web_service/response'
require 'alexa_web_service/display_directive'
require 'alexa_web_service/hint_directive'
require 'json'

RSpec.describe AlexaWebService::Response do

  it 'can issue a plain response' do
    expected_response = {"version"=>"1.0",
     "sessionAttributes"=>{},
     "response"=>
      {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
       "card"=>nil,
       "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
       "directives"=>[],
       "shouldEndSession"=>"true"}}.to_json

    response = described_class.new
    response.spoken_response = "Hello World!"
    expect(response.post).to eq expected_response
  end

  it 'can keep a session open' do
    expected_response = {"version"=>"1.0",
     "sessionAttributes"=>{},
     "response"=>
      {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
       "card"=>nil,
       "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
       "directives"=>[],
       "shouldEndSession"=>false}}.to_json

    response = described_class.new
    response.spoken_response = "Hello World!"
    response.end_session = false
    expect(response.post).to eq expected_response
  end

  it 'can use SSML if specified' do
    expected_response = {"version"=>"1.0",
     "sessionAttributes"=>{},
     "response"=>
      {"outputSpeech"=>{"type"=>"SSML", "ssml"=>"<speak>Hello World!</speak>"},
       "card"=>nil,
       "reprompt"=>{"outputSpeech"=>{"type"=>"SSML", "text"=>""}},
       "directives"=>[],
       "shouldEndSession"=>"true"}}.to_json

    response = described_class.new
    response.text_type = "ssml"
    response.speech_type = 'SSML'
    response.spoken_response = "<speak>Hello World!</speak>"
    expect(response.post).to eq expected_response
  end

  it 'can return a card with the response' do
    expected_response = {"version"=>"1.0",
     "sessionAttributes"=>{},
     "response"=>
      {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
       "card"=>{"type"=>"Simple", "title"=>"Card Title", "content"=>"Card Content"},
       "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
       "directives"=>[],
       "shouldEndSession"=>"true"}}.to_json

    response = described_class.new
    card = AlexaWebService::Card.new
    card.title = "Card Title"
    card.content = "Card Content"
    response.add_card(card.with_text)
    response.spoken_response = "Hello World!"
    expect(response.post).to eq expected_response
  end

  it 'can return a session attribute with the response' do
    expected_response = {"version"=>"1.0",
     "sessionAttributes"=>{"session_attribute"=>"string"},
     "response"=>
      {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
       "card"=>nil,
       "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
       "directives"=>[],
       "shouldEndSession"=>"true"}}.to_json

    response = described_class.new
    response.add_attribute("session_attribute", "string")
    response.spoken_response = "Hello World!"
    expect(response.post).to eq expected_response
  end

  describe '#add_directive' do
    before(:each) do
      $display_support = true
    end
    it 'can add a display directive to the response' do
      expected_response = {"version"=>"1.0",
       "sessionAttributes"=>{},
       "response"=>
        {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
         "card"=>nil,
         "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
         "directives"=>
          [{"type"=>"Display.RenderTemplate",
            "template"=>
             {"type"=>"BodyTemplate2",
              "token"=>"token",
              "backButton"=>"VISIBLE",
              "backgroundImage"=>{"contentDescription"=>"", "sources"=>[{"url"=>"", "size"=>"X_SMALL"}]},
              "title"=>"Template Title",
              "image"=>
               {"contentDescription"=>"template image",
                "sources"=>[{"url"=>"https://your_image.jpg", "size"=>"X_SMALL"}]},
              "textContent"=>
               {"primaryText"=>{"text"=>"Hello World!", "type"=>"RichText"},
                "secondaryText"=>{"text"=>nil, "type"=>"RichText"},
                "tertiaryText"=>{"text"=>nil, "type"=>"RichText"}}}}],
         "shouldEndSession"=>"true"}}.to_json

      response = described_class.new
      response.spoken_response = "Hello World!"
      display_template = AlexaWebService::DisplayDirective.new(type: "BodyTemplate2", token: "token", title: "Template Title")
      display_template.add_image("template image", "https://your_image.jpg")
      display_template.add_text(primary_text: "Hello World!")
      response.add_directive(display_template.directive)
      expect(response.post).to eq expected_response
    end

    it 'can add a hint directive to the response' do
      expected_response = {"version"=>"1.0",
       "sessionAttributes"=>{},
       "response"=>
        {"outputSpeech"=>{"type"=>"PlainText", "text"=>"Hello World!"},
         "card"=>nil,
         "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>""}},
         "directives"=>[{"type"=>"Hint", "hint"=>{"type"=>"PlainText", "text"=>"This is a hint"}}],
         "shouldEndSession"=>"true"}}.to_json

      response = described_class.new
      response.spoken_response = "Hello World!"
      hint = AlexaWebService::HintDirective.new("This is a hint")
      response.add_directive(hint.directive)
      expect(response.post).to eq expected_response
    end
  end
end