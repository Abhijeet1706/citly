class CreateLink < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :original
      t.string :shortened
      t.integer :clicks, :default => 0
      t.timestamps
    end
  end
end
