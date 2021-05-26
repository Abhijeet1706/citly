class PinToLinks < ActiveRecord::Migration[6.1]
  def change
    add_column :links, :pinned, :boolean, default: false
  end
end
