module Helpers
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
end
