class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :id
      t.string  :code
      t.string  :name
      t.string  :kind
      t.string  :unit
      t.string  :origin
      t.string  :vendor
      t.timestamps
    end
  end
end
