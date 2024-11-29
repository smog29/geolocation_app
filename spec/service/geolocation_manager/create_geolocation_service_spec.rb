require 'rails_helper'

RSpec.describe GeolocationManager::CreateGeolocationService, type: :service do
  let(:valid_ip) { "8.8.8.8" }
  let(:invalid_ip) { "invalid_ip" }

  describe '#call' do
    context 'when geolocation already exists' do
      before do
        FactoryBot.create(:geolocation, ip_address: valid_ip)
      end

      it 'returns a conflict status' do
        service = GeolocationManager::CreateGeolocationService.new(valid_ip)
        result = service.call

        expect(result.success).to eq(false)
        expect(result.errors).to eq("Geolocation already exists")
      end
    end

    context 'when geolocation data could not be retrieved' do
      before do
        allow_any_instance_of(GeolocationManager::GeolocationService).to receive(:fetch_geolocation_data).and_return({})
      end

      it 'returns an unprocessable entity status' do
        service = GeolocationManager::CreateGeolocationService.new(valid_ip)
        result = service.call

        expect(result.success).to eq(false)
        expect(result.errors).to eq("Geolocation data could not be retrieved")
      end
    end

    context 'when geolocation is created successfully' do
      before do
        allow_any_instance_of(GeolocationManager::GeolocationService).to receive(:fetch_geolocation_data).and_return({
          "ip" => valid_ip,
          "latitude" => 37.7749,
          "longitude" => -122.4194,
          "city" => "San Francisco",
          "country_name" => "United States"
        })
      end

      it 'creates a new geolocation and returns created status' do
        service = GeolocationManager::CreateGeolocationService.new(valid_ip)
        result = service.call

        expect(result.success).to eq(true)
        expect(result.data).to eq(Geolocation.last)
      end
    end
  end
end
