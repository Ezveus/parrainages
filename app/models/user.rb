class User < ActiveRecord::Base
  has_many :proteges, class_name: 'User', foreign_key: 'sponsor_id'
  belongs_to :sponsor, class_name: 'User'

  def self.with_no_proteges
    self.joins('LEFT JOIN users proteges ON proteges.sponsor_id = users.id').where('proteges.ID IS null')
  end

  # Do not use #size on this because it creates a SQL error. #length loads the query and returns expected result
  # This is because of the #group clause
  def self.with_more_than_x_proteges(x)
    self.joins('LEFT JOIN users proteges ON proteges.sponsor_id = users.id').group(:id)
        .having('COUNT(proteges.id) > ?', x)
  end

  # Do not use #size on this because it creates a SQL error. #length loads the query and returns expected result
  # This is because of the #group clause
  def self.who_sponsored_most_people(max_number_of_sponsors)
    self.joins('LEFT JOIN users proteges ON proteges.sponsor_id = users.id').group(:id)
        .order('COUNT(proteges.id) DESC').limit(max_number_of_sponsors)
  end

  def delete_with_responsoring
    self.proteges.find_each { |protege| protege.update(sponsor: self.sponsor) }
    self.destroy
  end

  def initial_sponsor
    self.sponsor.nil? ? self : self.sponsor.initial_sponsor
  end
end
