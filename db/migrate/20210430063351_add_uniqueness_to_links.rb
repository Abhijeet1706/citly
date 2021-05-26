class AddUniquenessToLinks < ActiveRecord::Migration[6.1]
  def change
    add_index :links, :original, :unique => true
    add_index :links, :shortened, :unique => true
  end
end
