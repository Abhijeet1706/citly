class Link < ApplicationRecord
  require "csv"

  validates :original,
            presence: true, 
            uniqueness: true, 
            format: URI::regexp(%w[http https]), 
            length: { minimum: 7 }
  validates :shortened,
            presence: true,
            uniqueness: true,
            format: URI::regexp(%w[http https])
  validates :pinned, 
            inclusion: [true, false]
  default_scope { order(pinned: :desc) }

  def self.to_csv
    attributes = %w{original shortened clicks pinned}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |link|
        csv << attributes.map { |attr| link.send(attr) }
      end
    end
  end
end