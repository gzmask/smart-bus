class CreateWebLocations < ActiveRecord::Migration
  def self.up
    create_table :web_locations do |t|
      t.integer :web_bus_id
      t.float :latitude
      t.float :longitude
      t.boolean :is_current
      t.boolean :is_end
      t.boolean :is_pickup
      t.boolean :is_dropdown
      t.integer :web_passenger_id
      t.integer :order_num

      t.timestamps
    end
  end

  def self.down
    drop_table :web_locations
  end
end
