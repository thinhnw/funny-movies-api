require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  describe "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('foo@bar.com').for(:email) }
    it { is_expected.to_not allow_value('foo@').for(:email) }
    it { is_expected.to_not allow_value('@bar.com').for(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end
end
