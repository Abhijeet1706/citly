class Link < ApplicationRecord
    require 'csv'
  
    enum status: { 
      unpinned: 0, 
      pinned: 1 
    }

  validates :link, 
            presence: true,  
            format: { with: URI.regexp }
  validates :shortened, 
            presence: true,
            length: { is: 7 }
  
  private

  def self.to_csv
    attributes = %w{link shortened clicks}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |link|
        csv << attributes.map{ |attr| link.send(attr) }
      end
    end
  end

  def self.organize
    pinned = self.pinned.order('updated_at DESC')
    unpinned = self.unpinned.order('updated_at DESC')
    pinned + unpinned
  end
end
