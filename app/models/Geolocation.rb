class Geolocation < ApplicationRecord
  validates :ip_address, uniqueness: true

  validates :ip_address, :latitude, :longiture, :city, :country, presence: true
end
