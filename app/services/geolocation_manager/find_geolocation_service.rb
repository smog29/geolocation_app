module GeolocationManager
  class FindGeolocationService < GeolocationService
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      geolocation = Geolocation.find_by(ip_address:)

      if geolocation
        Results::GeolocationResult.new(success: true, data: geolocation)
      else
        Results::GeolocationResult.new(success: false, errors: "Geolocation not found")
      end
    end
  end
end
