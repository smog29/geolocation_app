class CreateGeolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :geolocations do |t|
      t.timestamps
      t.string :ip_address, index: { unique: true }
      t.string :latitude
      t.string :longitude
      t.string :city
      t.string :country
    end
  end
end
