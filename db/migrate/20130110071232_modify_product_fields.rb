class ModifyProductFields < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.remove :unit
      t.remove :origin
      t.remove :kind
      t.column :code_format, :string
    end
  end
end
