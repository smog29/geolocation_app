require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  subject { FactoryBot.build(:geolocation) }

  describe 'validations' do
    it { should validate_presence_of(:ip_address) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_uniqueness_of(:ip_address).case_insensitive }
  end
end
