module GeolocationManager
  class CreateGeolocationService < GeolocationService
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      if Geolocation.exists?(ip_address:)
        return GeolocationResponse.new(success: false, errors: "Geolocation already exists")
      end

      geolocation_data = fetch_geolocation_data

      if geolocation_data.blank? || geolocation_data["ip"].blank?
        return GeolocationResponse.new(success: false, errors: "Geolocation data could not be retrieved")
      end

      create_geolocation(geolocation_data)
    end

    def create_geolocation(geolocation_data)
      geolocation = Geolocation.new(
        ip_address:,
        latitude: geolocation_data["latitude"],
        longitude: geolocation_data["longitude"],
        city: geolocation_data["city"],
        country: geolocation_data["country_name"]
      )
      if geolocation.save
        GeolocationResponse.new(success: true, data: geolocation)
      else
        GeolocationResponse.new(success: false, errors: geolocation.errors)
      end
    end
  end
end
