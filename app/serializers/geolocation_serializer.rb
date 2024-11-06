class GeolocationSerializer < ActiveModel::Serializer
  attributes :ip_address, :latitude, :longitude, :city, :country
end
