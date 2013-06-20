require 'active_record'

class Legislator < ActiveRecord::Base
  validates_presence_of :title,
                        :firstname,
                        :lastname, 
                        :party,
                        :state
                        # :in_office,
                        # :gender, 
                        # :phone, 
                        # :fax, 
                        # :website, 
                        # :webform,
                        # :twitter_id,
                        # :birthdate
  # belongs_to :state
  # belongs_to :party

  def self.legislators_for(state, title)
    self.where('title = ? AND state = ?', title.capitalize[0..2], state)
  end

  def name_and_party
    "#{firstname} #{lastname} (#{party})"
  end

  def self.print_senators_and_reps_for(state)
    titles = ['Senator', 'Representative']
    titles.each do |title|
      puts "\n#{state} #{title}s:"
      legislators_for(state, title).each { |senator| puts senator.name_and_party }
    end
  end

  def self.active_legislators(title)
    self.where('title = ? AND in_office = ?', title, true)
  end

  def self.print_active_gender_stats(gender)
    titles = ['Senator', 'Representative']
    titles.each do |title|
      actives = self.active_legislators(title.capitalize[0..2])
      gender_count = actives.where('gender = ?', gender.capitalize[0]).count
      total_count  = actives.count
      gender_percentage = (gender_count * 100 / total_count)
      puts "#{gender.capitalize} #{title.capitalize}s: " + 
      "#{gender_count} (#{gender_percentage}%)"
    end
  end

  def self.print_totals_by_title
    titles = ['Senator', 'Representative', 'Delegate', 'Commissioner']
    titles.each do |title|
      num_legislators = self.where('title LIKE ?', "#{title[0]}%").count
      puts "#{title}s: #{num_legislators}"
    end
  end

  def self.print_legislator_counts_by_state
    self.group('state').each do |legislator|
      state = legislator.state
      output = []
      titles = ['Senator', 'Representative', 'Delegate', 'Commissioner']
      titles.each do |title|
        num = legislators_for(state, title).count
        output << "#{num} #{title}" if num == 1
        output << "#{num} #{title}s" if num > 1
      end
      puts "#{state}: " + output.join(", ")
    end
  end

  def self.delete_inactives
    self.destroy_all(:in_office => false)
  end
end

# class Senator < Legislator
# end

# class Representative < Legislator
# end

# # class State < ActiveRecord::Base
#   validates_length_of :senators, :is => 2
#   validates_length_of :representatives, :minimum => 1

#   has_many :senators
#   has_many :representatives
# end

# class Party < ActiveRecord::Base
#   has_many :senators
#   has_many :representatives
# end