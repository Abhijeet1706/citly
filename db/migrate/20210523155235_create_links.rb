class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :original, null: false
      t.text :shortened, null: false
      t.integer :clicked, :default => 0
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
