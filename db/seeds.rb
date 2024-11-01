# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

records = [
  {
    "ip_address": "212.77.98.9",
    "latitude": "54.31930923461914",
    "longitude": "18.63736915588379",
    "city": "Gdańsk",
    "country": "Poland"
  },
  {
  "ip_address": "57.144.110.1",
  "latitude": "38.98371887207031",
  "longitude": "-77.38275909423828",
  "city": "Herndon",
  "country": "United States"
  },
  {
  "ip_address": "142.250.203.195",
  "latitude": "37.38801956176758",
  "longitude": "-122.07431030273438",
  "city": "Mountain View",
  "country": "United States"
  },
  {
  "ip_address": "62.108.161.147",
  "latitude": "54.20751190185547",
  "longitude": "16.20244026184082",
  "city": "Koszalin",
  "country": "Poland"
  }
]

records.each do |record|
  Geolocation.find_or_create_by!(record)
end
