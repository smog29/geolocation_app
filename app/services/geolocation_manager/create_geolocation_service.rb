module GeolocationManager
  class CreateGeolocationService < GeolocationService
    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      if Geolocation.exists?(ip_address:)
        return Results::GeolocationResult.new(success: false, errors: "Geolocation already exists")
      end

      geolocation_data = fetch_geolocation_data

      if geolocation_data.blank? || geolocation_data["ip"].blank?
        return Results::GeolocationResult.new(success: false, errors: "Geolocation data could not be retrieved")
      end

      create_geolocation(geolocation_data)
    end

    private

    attr_reader :ip_address

    def create_geolocation(geolocation_data)
      geolocation = Geolocation.new(
        ip_address:,
        latitude: geolocation_data["latitude"],
        longitude: geolocation_data["longitude"],
        city: geolocation_data["city"],
        country: geolocation_data["country_name"]
      )
      if geolocation.save
        Results::GeolocationResult.new(success: true, data: geolocation)
      else
        Results::GeolocationResult.new(success: false, errors: geolocation.errors)
      end
    end
  end
end
