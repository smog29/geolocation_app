module Api
  module V1
    class GeolocationsController < ApplicationController
      require "net/http"
      require "json"
      require "resolv"

      BASE_URL = "http://api.ipstack.com"
      ACCESS_KEY = ENV["IPSTACK_API_KEY"]

      skip_before_action :verify_authenticity_token

      before_action :validate_address!, only: %i[create show update destroy]

      def index
        geolocations = Geolocation.all
        render json: geolocations
      end

      def show
        ip_address = resolve_address(params[:address])
        geolocation = Geolocation.find_by(ip_address:)

        if geolocation
          render json: geolocation
        else
          render json: { error: "Geolocation not found" }, status: :not_found
        end
      end

      def create
        ip_address = resolve_address(params[:address])

        if Geolocation.exists?(ip_address:)
          render json: { error: "Geolocation already exists" }, status: :conflict
          return
        end

        geolocation_data = fetch_geolocation_data(params[:address])

        if geolocation_data.blank? || geolocation_data["ip"].blank?
          render json: { error: "Geolocation data could not be retrieved" }, status: :unprocessable_entity
          return
        end

        geolocation = Geolocation.new(
          ip_address:,
          latitude: geolocation_data["latitude"],
          longitude: geolocation_data["longitude"],
          city: geolocation_data["city"],
          country: geolocation_data["country_name"]
        )
        if geolocation.save
          render json: geolocation, status: :created
        else
          render json: geolocation.errors, status: :unprocessable_entity
        end
      end

      def update
        ip_address = resolve_address(params[:address])
        geolocation = Geolocation.find_by(ip_address:)

        if geolocation.blank?
          render json: { error: "Geolocation not found" }, status: :not_found
          return
        end

        geolocation_data = fetch_geolocation_data(ip_address)

        if geolocation_data.present? && geolocation_data["ip"].present?
          geolocation.update(
            latitude: geolocation_data["latitude"],
            longitude: geolocation_data["longitude"],
            city: geolocation_data["city"],
            country: geolocation_data["country_name"]
          )
          render json: geolocation
        else
          render json: { error: "Geolocation data could not be retrieved" }, status: :unprocessable_entity
        end
      end

      def destroy
        ip_address = resolve_address(params[:address])
        geolocation = Geolocation.find_by(ip_address:)

        if geolocation
          geolocation.destroy
          render json: { message: "Geolocation deleted" }
        else
          render json: { error: "Geolocation not found" }, status: :not_found
        end
      end

      private

      def fetch_geolocation_data(identifier)
        url = "#{BASE_URL}/#{identifier}?access_key=#{ACCESS_KEY}"
        response = Net::HTTP.get(URI(url))
        JSON.parse(response) if response
      rescue StandardError => e
        Rails.logger.error("Error fetching geolocation data: #{e.message}")
        nil
      end

      def resolve_address(address)
        Resolv.getaddress(address)
      rescue Resolv::ResolvError
        nil
      end

      def valid_address?(address)
        address.present? && address.is_a?(String)
      end

      def validate_address!
        if !valid_address?(params[:address]) || resolve_address(params[:address]).blank?
          render json: { error: "Valid IP address or URL must be provided" }, status: :unprocessable_entity
        end
      end
    end
  end
end
