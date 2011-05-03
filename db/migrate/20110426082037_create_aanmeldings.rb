class CreateAanmeldings < ActiveRecord::Migration
  def self.up
    create_table :aanmeldings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :aanmeldings
  end
end
