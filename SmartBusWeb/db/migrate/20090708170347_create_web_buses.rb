class CreateWebBuses < ActiveRecord::Migration
  def self.up
    create_table :web_buses do |t|
      t.integer :capacity

      t.timestamps
    end
  end

  def self.down
    drop_table :web_buses
  end
end
