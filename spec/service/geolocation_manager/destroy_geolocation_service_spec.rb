require 'rails_helper'

RSpec.describe GeolocationManager::DestroyGeolocationService, type: :service do
  let(:existing_ip) { "8.8.8.8" }
  let(:nonexistent_ip) { "9.9.9.9" }

  before do
    FactoryBot.create(:geolocation, ip_address: existing_ip)
  end

  describe "#call" do
    context "when the geolocation exists" do
      it "destroys the geolocation and returns a successful response" do
        service = GeolocationManager::DestroyGeolocationService.new(existing_ip)
        result = service.call

        expect(result.success).to eq(true)
        expect(Geolocation.find_by(ip_address: existing_ip)).to be_nil
      end
    end

    context "when the geolocation does not exist" do
      it "returns an error response" do
        service = GeolocationManager::DestroyGeolocationService.new(nonexistent_ip)
        result = service.call

        expect(result.success).to eq(false)
        expect(result.errors).to eq("Geolocation not found")
      end
    end
  end
end
