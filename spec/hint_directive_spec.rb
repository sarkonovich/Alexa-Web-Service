require 'alexa_web_service/hint_directive.rb'

RSpec.describe AlexaWebService::HintDirective do
  subject(:hint) { described_class  }

  describe '#directive' do
    it 'generates a hint to be used with certain display templates' do
      expected_result = {
        "type": "Hint",
        "hint": {
          "type": "PlainText",
          "text": "This is the hint"
        }
      }

      hint = described_class.new("This is the hint")
      expect(hint.directive).to eq expected_result
    end
  end
end