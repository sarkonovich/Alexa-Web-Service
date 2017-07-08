module AlexaWebService
  class ShowResponse
    attr_accessor :directives

    def initialize(type:, token:, title:, back_button:, background_image:, image:)
      @directives = [
        {
          "type": "Display.RenderTemplate",
          "template": {
            "type": type,
            "token": token,
            "backButton": back_button,
            "backgroundImage": background_image,
            "title": title,
            "image": image
          }
        }
      ]
    end

    def add_hint(hint_content)
      @directives << {
      "type": "Hint",
      "hint": {
        "type": "PlainText",
        "text": hint_content
        }
      }
    end

    def create_show_image_object(content_description = '', url = '')
      {
        "contentDescription": content_description,
        "sources": [
          {
            "url": url
          }
        ]
      }   
      
    end

    def add_background_image(image_object)
      begin
        @directives.first[:template][:backgroundImage] = image_object
      rescue NoMethodError => e
        p "ERROR: #{e}: You need to add a Template before adding a background"
      end
    end

    def add_show_body_item(text_object: {}, image_object: {})
      begin
        @directives.first[:template][:image] = image_object
        self.directives[0][:template].merge!(text_object)
      rescue NoMethodError => e
         p "ERROR: #{e}: You need to add a Body Template before adding body content"
      end 
    end

    # To create Show lists, first create image and text objects and then add show list item.
    def add_show_list_item(
      token: '', 
      image_object: {},
      text_object: {}
      )
      self.directives[0][:template][:listItems] ||= []
      list_items = { 
        "token": token,
        "image": image_object,
        "textContent": text_object[:textContent]
      }
      begin
        self.directives[0][:template][:listItems] << list_items
      rescue NoMethodError => e
         p "ERROR: #{e}: You need to add a List Template before adding list content"
      end 
    end

    def create_show_text_object(
        primary_text: '',
        primary_text_type: "RichText",
        secondary_text: '',
        secondary_text_type: "RichText",
        tertiary_text: '',
        tertiary_text_type: "RichText"
      )
      {
        "textContent": {
          "primaryText": {
            "text": primary_text,
            "type": primary_text_type
          },
          "secondaryText": {
            "text": secondary_text,
            "type": secondary_text_type
          },
          "tertiaryText": {
            "text": tertiary_text,
            "type": tertiary_text_type
          }
        }
      }
    end
  end
end
