module GeolocationManager
  class UpdateGeolocationService < GeolocationService
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      geolocation = Geolocation.find_by(ip_address:)

      if geolocation.blank?
        return GeolocationResponse.new(success: false, errors: "Geolocation not found")
      end

      update_geolocation(geolocation, fetch_geolocation_data)
    end

    private

    def update_geolocation(geolocation, geolocation_data)
      if geolocation_data.present? && geolocation_data["ip"].present?
        geolocation.update(
          latitude: geolocation_data["latitude"],
          longitude: geolocation_data["longitude"],
          city: geolocation_data["city"],
          country: geolocation_data["country_name"]
        )
        GeolocationResponse.new(success: true, data: geolocation)
      else
        GeolocationResponse.new(success: false, errors: "Geolocation data could not be retrieved")
      end
    end
  end
end
