module AlexaWebService
  class Card
    attr_accessor :title, :content, :small_image, :large_image, :permissions

    def initialize(type = 'text_card')
      @title = ''
      @content = ''
      @small_image = nil
      @large_image = nil
      @type = type
      @permissions = []
    end

    def with_image
      {
        "type": "Standard",
        "title": title,
        "text": content,
        "image": {
          "smallImageUrl": small_image,
          "largeImageUrl": large_image
          }
        }
    end

    def with_text
      {
        "type": "Simple",
        "title": title,
        "content": content
      }
    end

    def linking
      {"type": "LinkAccount"}
    end

    # Will only return permissions requested in skill configuration
    # Possible values for permissions:
    # write for notifications:  "write::alexa:devices:all:notifications:standard"
    # read for full address: "read::alexa:device:all:address"
    # read for restricted address: "read::alexa:device:all:address:country_and_postal_code"
    
    def add_permission(permission) 
      self.permissions << permission
    end

    def with_permission
      {
      "type": "AskForPermissionsConsent", "permissions": permissions
      }
    end
  end
end
