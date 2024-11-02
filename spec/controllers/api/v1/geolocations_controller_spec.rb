require 'rails_helper'

RSpec.describe Api::V1::GeolocationsController, type: :controller do
  let(:ip_address) { "162.158.202.18" }
  let(:resolved_ip) { ip_address }
  let(:valid_attributes) { { address: "example.com" } }

  before do
    stub_request(:get, /api.ipstack.com/).to_return(
      status: 200,
      body: {
        "ip" => ip_address,
        "latitude" => 10.0,
        "longitude" => 20.0,
        "city" => "Sample City",
        "country_name" => "Sample Country"
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    allow(Resolv).to receive(:getaddress).and_return(resolved_ip)
  end

  describe "GET #index" do
    before { FactoryBot.create_list(:geolocation, 3) }

    it "returns a list of geolocations" do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET #show" do
    before { FactoryBot.create(:geolocation, ip_address: ip_address) }

    context "when address is provided and geolocation exists" do
      it "returns the geolocation" do
        get :show, params: { address: "example.com" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["ip_address"]).to eq(ip_address)
      end
    end

    context "when geolocation is not found" do
      let(:resolved_ip) { "116.172.139.102" }

      it "returns not found status" do
        get :show, params: { address: "nonexistent.com" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when address is not valid" do
      it "returns unprocessable entity status" do
        get :show, params: { address: "" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Valid IP address or URL must be provided")
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes and new address" do
      it "creates a new geolocation" do
        expect {
          post :create, params: valid_attributes
        }.to change(Geolocation, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["ip_address"]).to eq(ip_address)
      end
    end

    context "when geolocation already exists" do
      before { FactoryBot.create(:geolocation, ip_address: ip_address) }

      it "returns conflict status" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)["error"]).to eq("Geolocation already exists")
      end
    end

    context "when address is invalid" do
      it "returns unprocessable entity status" do
        post :create, params: { address: "" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Valid IP address or URL must be provided")
      end
    end
  end

  describe "PUT #update" do
    before { FactoryBot.create(:geolocation, ip_address: ip_address) }

    context "when geolocation exists" do
      it "updates the geolocation" do
        put :update, params: { address: "example.com" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["city"]).to eq("Sample City")
      end
    end

    context "when geolocation is not found" do
      let(:resolved_ip) { "116.172.139.102" }

      it "returns not found status" do
        put :update, params: { address: "nonexistent.com" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when address is invalid" do
      it "returns unprocessable entity status" do
        put :update, params: { address: "" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Valid IP address or URL must be provided")
      end
    end
  end

  describe "DELETE #destroy" do
    before { FactoryBot.create(:geolocation, ip_address: ip_address) }

    context "when geolocation exists" do
      it "deletes the geolocation" do
        expect {
          delete :destroy, params: { address: "example.com" }
        }.to change(Geolocation, :count).by(-1)
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("Geolocation deleted")
      end
    end

    context "when geolocation is not found" do
      let(:resolved_ip) { "116.172.139.102" }

      it "returns not found status" do
        delete :destroy, params: { address: "nonexistent.com" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when address is invalid" do
      it "returns unprocessable entity status" do
        delete :destroy, params: { address: "" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Valid IP address or URL must be provided")
      end
    end
  end
end
