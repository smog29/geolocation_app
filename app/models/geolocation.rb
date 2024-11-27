class Geolocation < ApplicationRecord
  validates :ip_address, uniqueness: { case_sensitive: false }

  validates :ip_address, :latitude, :longitude, :city, :country, presence: true
end
