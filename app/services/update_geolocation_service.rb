class UpdateGeolocationService < GeolocationService
  def initialize(ip_address)
    @ip_address = ip_address
  end

  def call
    geolocation = Geolocation.find_by(ip_address: @ip_address)

    if geolocation.blank?
      return { json: { error: "Geolocation not found" }, status: :not_found }
    end

    geolocation_data = fetch_geolocation_data

    if geolocation_data.present? && geolocation_data["ip"].present?
      geolocation.update(
        latitude: geolocation_data["latitude"],
        longitude: geolocation_data["longitude"],
        city: geolocation_data["city"],
        country: geolocation_data["country_name"]
      )
      { json: geolocation, status: :ok }
    else
      { json: { error: "Geolocation data could not be retrieved" }, status: :unprocessable_entity }
    end
  end
end
