ALEXA_RESPONSE = {
"body"=>
  {"version"=>"1.0",
   "response"=>
    {"outputSpeech"=>
      {"type"=>"PlainText",
       "text"=>
        "I'm Alexa, and I've got something to say to you!"},
     "card"=>
      {"type"=>"Standard",
       "title"=>"Image Card Title",
       "text"=>
        "Image Card Content",
       "image"=>
        {"smallImageUrl"=>"https://small-card.jpg",
         "largeImageUrl"=>"https://large-card.jpg"}},
     "directives"=>
      [{"type"=>"Display.RenderTemplate",
        "template"=>
         {"type"=>"BodyTemplate3",
          "token"=>"token",
          "backgroundImage"=>
           {"contentDescription"=>"background",
            "sources"=>[{"url"=>"https://background.jpg", "size"=>"x-small", "widthPixels"=>0, "heightPixels"=>0}]},
          "image"=>
           {"contentDescription"=>"Pretty Picture", "sources"=>[{"url"=>"https://pretty_picture.png", "size"=>"x-small", "widthPixels"=>0, "heightPixels"=>0}]},
          "title"=>"Alexa Skill",
          "textContent"=>
           {"primaryText"=>
             {"type"=>"RichText",
              "text"=>"here a first line of text"},
            "secondaryText"=>{"type"=>"RichText", "text"=>"here's a second line of text"},
            "tertiaryText"=>{"type"=>"RichText", "text"=>"here's a third line of text"}},
          "backButton"=>"VISIBLE"}}],
     "reprompt"=>{"outputSpeech"=>{"type"=>"PlainText", "text"=>"I'm still here!"}},
     "shouldEndSession"=>false},
   "sessionAttributes"=>
    {"session_attribute"=>1}}}