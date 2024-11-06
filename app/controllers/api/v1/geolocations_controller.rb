module Api
  module V1
    class GeolocationsController < ApplicationController
      require "net/http"
      require "json"
      require "resolv"

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

        service = CreateGeolocationService.new(ip_address).call

        render json: service[:json], status: service[:status]
      end

      def update
        ip_address = resolve_address(params[:address])
        service = UpdateGeolocationService.new(ip_address).call

        render json: service[:json], status: service[:status]
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
