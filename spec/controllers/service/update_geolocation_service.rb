require 'rails_helper'

RSpec.describe UpdateGeolocationService, type: :service do
  let(:valid_ip) { "8.8.8.8" }
  let(:non_existent_ip) { "1.1.1.1" }

  before { FactoryBot.create(:geolocation, ip_address: valid_ip) }

  describe '#call' do
    context 'when geolocation is not found' do
      it 'returns a not found status' do
        service = UpdateGeolocationService.new(non_existent_ip)
        result = service.call

        expect(result[:status]).to eq(:not_found)
        expect(result[:json][:error]).to eq("Geolocation not found")
      end
    end

    context 'when geolocation data could not be retrieved' do
      before do
        allow_any_instance_of(GeolocationService).to receive(:fetch_geolocation_data).and_return({})
      end

      it 'returns an unprocessable entity status' do
        service = UpdateGeolocationService.new(valid_ip)
        result = service.call

        expect(result[:status]).to eq(:unprocessable_entity)
        expect(result[:json][:error]).to eq("Geolocation data could not be retrieved")
      end
    end

    context 'when geolocation is updated successfully' do
      before do
        allow_any_instance_of(GeolocationService).to receive(:fetch_geolocation_data).and_return({
          "ip" => valid_ip,
          "latitude" => "37.7749",
          "longitude" => "-122.4194",
          "city" => "San Francisco",
          "country_name" => "United States"
        })
      end

      it 'updates the geolocation and returns a successful response' do
        service = UpdateGeolocationService.new(valid_ip)
        result = service.call

        expect(result[:status]).to eq(:ok)
        expect(result[:json].latitude).to eq("37.7749")
        expect(result[:json].longitude).to eq("-122.4194")
        expect(result[:json].city).to eq("San Francisco")
      end
    end
  end
end
