require 'rails_helper'

RSpec.describe GeolocationManager::FindGeolocationService, type: :service do
  let(:existing_ip) { "8.8.8.8" }
  let(:nonexistent_ip) { "9.9.9.9" }

  before do
    FactoryBot.create(:geolocation, ip_address: existing_ip)
  end

  describe "#call" do
    context "when the geolocation exists" do
      it "returns a successful response with the geolocation data" do
        service = GeolocationManager::FindGeolocationService.new(existing_ip)
        result = service.call

        expect(result.success).to eq(true)
        expect(result.data).to be_a(Geolocation)
        expect(result.data.ip_address).to eq(existing_ip)
      end
    end

    context "when the geolocation does not exist" do
      it "returns an error response" do
        service = GeolocationManager::FindGeolocationService.new(nonexistent_ip)
        result = service.call

        expect(result.success).to eq(false)
        expect(result.errors).to eq("Geolocation not found")
        expect(result.data).to be_nil
      end
    end
  end
end
