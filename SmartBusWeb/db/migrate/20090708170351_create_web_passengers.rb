class CreateWebPassengers < ActiveRecord::Migration
  def self.up
    create_table :web_passengers do |t|
      t.string :password
      t.integer :web_bus_id

      t.timestamps
    end
  end

  def self.down
    drop_table :web_passengers
  end
end
