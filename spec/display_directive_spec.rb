require 'alexa_web_service/display_directive.rb'
require 'helpers.rb'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe AlexaWebService::DisplayDirective do
  subject(:display) { described_class.new }

  describe '#image_object' do
    it 'generates a default image object to be used in a display directive' do
      expected_result = {
        "contentDescription": '',
        "sources": [
          {
            "url": '',
            "size": 'X_SMALL'
          }
        ]
      }

      # image = described_class.new.image_object('dislay image', 'https://your_image_url')
      image = display.image_object
      expect(image).to eq expected_result
    end

    it 'generates an image object with a specified size' do
      expected_result = {
        "contentDescription": 'dislay image',
        "sources": [
          {
            "url": 'https://your_image_url',
            "size": 'X_LARGE'
          }
        ]
      }

      image = display.image_object('dislay image', 'https://your_image_url', "X_LARGE")
      expect(image).to eq expected_result
    end
  end

  describe '#text_object' do
    it 'generates a blank text object to be used in a display directive' do
      expected_result = {
        "primaryText": {
          "text": nil,
          "type": "RichText"
        },
        "secondaryText": {
          "text": nil,
          "type": "RichText"
        },
        "tertiaryText": {
          "text": nil,
          "type": "RichText"
        }
      }

      text = described_class.new.text_object
      expect(text).to eq expected_result
    end

    it 'allows generate a text object with primary text' do
      expected_result = {
        "primaryText": {
          "text": "This is primary text",
          "type": "RichText"
        },
        "secondaryText": {
          "text": nil,
          "type": "RichText"
        },
        "tertiaryText": {
          "text": nil,
          "type": "RichText"
        }
      }

      text = described_class.new.text_object(primary_text: "This is primary text")
      expect(text).to eq expected_result
    end

    it 'allows generate a text object with primary and secondary text' do
        expected_result = {
          "primaryText": {
            "text": "This is primary text",
            "type": "RichText"
          },
          "secondaryText": {
            "text": "This is secondary text",
            "type": "RichText"
          },
          "tertiaryText": {
            "text": nil,
            "type": "RichText"
          }
        }

        text = described_class.new.text_object(primary_text: "This is primary text", 
                                              secondary_text: "This is secondary text")
        expect(text).to eq expected_result
      end

      it 'allows generate a text object with primary,secondary, and tertiary text' do
        expected_result = {
          "primaryText": {
            "text": "This is primary text",
            "type": "RichText"
          },
          "secondaryText": {
            "text": "This is secondary text",
            "type": "RichText"
          },
          "tertiaryText": {
            "text": "This is tertiary text",
            "type": "RichText"
          }
        }

        text = described_class.new.text_object(primary_text: "This is primary text", 
                                              secondary_text: "This is secondary text",
                                              tertiary_text: "This is tertiary text")
        expect(text).to eq expected_result
      end
    end

  describe '#directive' do
    it 'generates a display directive' do
      expected_result = {
        "type": "Display.RenderTemplate",
        "template": {
          "type": "BodyTemplate1",
          "token": "",
          "backButton": "VISIBLE",
          "backgroundImage": image_object,
          "title": "",
          "image": image_object,
          "textContent": {}
        }
      }

      expect(display.directive).to eq expected_result
    end
  end

  describe "#add_text" do
    it 'adds text object to the display directive' do
      expected_result = {
        :type=>"Display.RenderTemplate",
        :template=> {
          :type=>"BodyTemplate1",
          :token=>"",
          :backButton=>"VISIBLE",
          :backgroundImage=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
          :title=>"",
          :image=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
          :textContent=>
            {:primaryText=>{:text=>"This is some text", :type=>"RichText"},
            :secondaryText=>{:text=>nil, :type=>"RichText"},
            :tertiaryText=>{:text=>nil, :type=>"RichText"}
           }
         }
       }
      display.add_text(primary_text: "This is some text")
      expect(display.directive).to eq expected_result
    end
  end

  describe "#add_image" do
    it 'adds an image object to the display directive' do
      expected_result = {:type=>"Display.RenderTemplate",
       :template=>
        {:type=>"BodyTemplate1",
         :token=>"",
         :backButton=>"VISIBLE",
         :backgroundImage=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
         :title=>"",
         :image=>{:contentDescription=>"image object", :sources=>[{:url=>"https://image_url", :size=>"X_SMALL"}]},
         :textContent=>{}
         }
       }
      display.add_image('image object', 'https://image_url')
      expect(display.directive).to eq expected_result
    end
  end

  describe "#add_background_image" do
    it 'adds a background image object to the display directive' do
      expected_result = {:type=>"Display.RenderTemplate",
       :template=>
        {:type=>"BodyTemplate1",
         :token=>"",
         :backButton=>"VISIBLE",
         :backgroundImage=>{:contentDescription=>"image object", :sources=>[{:url=>"https://image_url", :size=>"X_SMALL"}]},
         :title=>"",
         :image=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
         :textContent=>{}
         }
       }
      display.add_background_image('image object', 'https://image_url')
      expect(display.directive).to eq expected_result
    end
  end

  describe "#add_list_item" do
    it 'adds items to a list display template' do
      expected_result = {:type=>"Display.RenderTemplate",
       :template=>
        {:type=>"BodyTemplate1",
         :token=>"",
         :backButton=>"VISIBLE",
         :backgroundImage=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
         :title=>"",
         :image=>{:contentDescription=>"", :sources=>[{:url=>"", :size=>"X_SMALL"}]},
         :textContent=>{},
         :listItems=>
          [{:token=>"list item one",
            :image=>{:contentDescription=>"dislay image", :sources=>[{:url=>"https://your_image_url", :size=>"X_SMALL"}]},
            :textContent=>
             {:primaryText=>{:text=>"This is the primary text", :type=>"RichText"},
              :secondaryText=>{:text=>nil, :type=>"RichText"},
              :tertiaryText=>{:text=>nil, :type=>"RichText"}}
            }
          ]
        }
      } 
      image = display.image_object('dislay image', 'https://your_image_url')
      text = display.text_object(primary_text: "This is the primary text")
      display.add_list_item(token: 'list item one', image_object: image, text_object: text)
      expect(display.directive).to eq expected_result
    end
  end
end