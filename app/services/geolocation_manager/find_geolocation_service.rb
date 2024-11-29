module GeolocationManager
  class FindGeolocationService < GeolocationService
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      geolocation = Geolocation.find_by(ip_address:)

      if geolocation
        GeolocationResponse.new(success: true, data: geolocation)
      else
        GeolocationResponse.new(success: false, errors: "Geolocation not found")
      end
    end
  end
end
