class CreateGeolocationService < GeolocationService
  def initialize(ip_address)
    @ip_address = ip_address
  end

  def call
    if Geolocation.exists?(ip_address: @ip_address)
      return { json: { error: "Geolocation already exists" }, status: :conflict }
    end

    geolocation_data = fetch_geolocation_data

    if geolocation_data.blank? || geolocation_data["ip"].blank?
      return { json: { error: "Geolocation data could not be retrieved" }, status: :unprocessable_entity }
    end

    geolocation = Geolocation.new(
      ip_address: @ip_address,
      latitude: geolocation_data["latitude"],
      longitude: geolocation_data["longitude"],
      city: geolocation_data["city"],
      country: geolocation_data["country_name"]
    )
    if geolocation.save
      { json: geolocation, status: :created }
    else
      { json: geolocation.errors, status: :unprocessable_entity }
    end
  end
end
