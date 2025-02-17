require 'rails_helper'

RSpec.describe Videos::FetchService, type: :service do
  describe '#call' do
    it 'raises NotImplementedError when called on the base class' do
      service = Videos::FetchService.new('some_url')

      expect { service.call }.to raise_error(NotImplementedError, "Subclasses must implement this method")
    end
  end
end
