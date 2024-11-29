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
        response = GeolocationManager::FindGeolocationService.new(ip_address).call

        if response.success
          render json: response.data
        else
          render json: { errors: response.errors }, status: :not_found
        end
      end

      def create
        response = GeolocationManager::CreateGeolocationService.new(ip_address).call

        if response.success
          render json: response.data, status: :created
        else
          render json: { errors: response.errors }, status: :conflict
        end
      end

      def update
        response = GeolocationManager::UpdateGeolocationService.new(ip_address).call

        if response.success
          render json: response.data
        else
          render json: { errors: response.errors }, status: :not_found
        end
      end

      def destroy
        response = GeolocationManager::DestroyGeolocationService.new(ip_address).call

        if response.success
          render json: { message: "Geolocation deleted" }
        else
          render json: { errors: response.errors }, status: :not_found
        end
      end

      private

      def ip_address
        resolve_address(params[:address])
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
          render json: { errors: "Valid IP address or URL must be provided" }, status: :unprocessable_entity
        end
      end
    end
  end
end
