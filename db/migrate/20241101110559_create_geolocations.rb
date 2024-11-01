class CreateGeolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :geolocations do |t|
      t.timestamps
      t.string :ip_address, index: { unique: true }, null: false
      t.string :latitude, null: false
      t.string :longitude, null: false
      t.string :city, null: false
      t.string :country, null: false
    end
  end
end
