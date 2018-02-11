
module AlexaWebService    
  class DisplayDirective
    attr_accessor :directive

    def initialize(type: "BodyTemplate1", token: "", back_button: "VISIBLE", title: "")
      @directive = {
        "type": "Display.RenderTemplate",
        "template": {
          "type": type,
          "token": token,
          "backButton": back_button,
          "backgroundImage": image_object,
          "title": title,
          "image": image_object,
          "textContent": {}
        }
      }
    end
    
    def image_object(content_description = '', url = '', size = 'X_SMALL')
      {
        "contentDescription": content_description,
        "sources": [
          {
            "url": url,
            "size": size
          }
        ]
      }
    end
    
    def add_image(content_description, url, size = 'X_SMALL')
      @directive[:template][:image] = image_object(content_description, url, size = 'X_SMALL')    
    end
    
    def add_background_image(content_description, url, size = 'X_SMALL')
      @directive[:template][:backgroundImage] = image_object(content_description, url, size = 'X_SMALL')  
    end

    def text_object(primary_text: nil, secondary_text: nil, tertiary_text: nil)
      {
        "primaryText": {
          "text": primary_text,
          "type": "RichText"
        },
        "secondaryText": {
          "text": secondary_text,
          "type": "RichText"
        },
        "tertiaryText": {
          "text": tertiary_text,
          "type": "RichText"
        }
      }
    end

    def add_text(primary_text:, secondary_text: nil, tertiary_text: nil)
      @directive[:template][:textContent] = text_object(primary_text: primary_text, secondary_text: secondary_text, tertiary_text: tertiary_text)
    end

    # To create Show lists, first create image and text objects and then add show list item.
    def add_list_item(token: '', image_object: {}, text_object: {})
      item = { 
        "token": token,
        "image": image_object,
        "textContent": text_object
      }
      @directive[:template][:listItems] ||= []
      @directive[:template][:listItems] << item
    end
  end
end