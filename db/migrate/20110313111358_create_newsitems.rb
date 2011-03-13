class CreateNewsitems < ActiveRecord::Migration
  def self.up
    create_table :newsitems do |t|
      t.string :title
      t.string :subtitle
      t.text :body
      t.boolean :visible
      
      t.timestamps
    end
  end

  def self.down
    drop_table :newsitems
  end
end
