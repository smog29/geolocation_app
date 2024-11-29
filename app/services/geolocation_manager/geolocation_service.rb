require "net/http"
require "json"

module GeolocationManager
  class GeolocationService
    BASE_URL = "http://api.ipstack.com"
    ACCESS_KEY = ENV["IPSTACK_API_KEY"]

    private

    def fetch_geolocation_data
      url = "#{BASE_URL}/#{@ip_address}?access_key=#{ACCESS_KEY}"
      response = Net::HTTP.get(URI(url))
      JSON.parse(response) if response
    rescue StandardError => e
      Rails.logger.error("Error fetching geolocation data: #{e.message}")
      nil
    end
  end
end
