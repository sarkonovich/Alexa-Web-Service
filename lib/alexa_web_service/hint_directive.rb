module AlexaWebService    
  class HintDirective
    attr_accessor :directive

    def initialize(hint) 
        @directive = {
        "type": "Hint",
        "hint": {
          "type": "PlainText",
          "text": hint
        }
      }
    end
  end
end