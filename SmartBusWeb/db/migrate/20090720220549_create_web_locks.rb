class CreateWebLocks < ActiveRecord::Migration
  def self.up
    create_table :web_locks do |t|
      t.string :resource
      t.boolean :in_use

      t.timestamps
    end
  end

  def self.down
    drop_table :web_locks
  end
end
