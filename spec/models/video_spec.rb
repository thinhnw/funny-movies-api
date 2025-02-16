require 'rails_helper'

RSpec.describe Video, type: :model do
  subject { build(:video) }
  describe 'validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:url) }
  end
end
