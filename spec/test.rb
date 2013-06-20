require_relative '../db/config'
require_relative '../app/models/legislator'

def senators_for(state)
  Legislator.where('title = ? AND state = ?', 'Sen', state)
end

def representatives_for(state)
  Legislator.where('title = ? AND state = ?', 'Rep', state)
end

def name_and_party_of(legislator)
  "#{legislator.firstname} #{legislator.lastname} (#{legislator.party})"
end

def print_senators_and_reps_for(state)
  puts "#{state} Senators:"
  senators_for(state).each { |senator| puts name_and_party_of(senator) }
  puts
  puts "#{state} Representatives:"
  representatives_for(state).each { |rep| puts name_and_party_of(rep) }
end

# print_senators_and_reps_for("IL")
# puts
# print_senators_and_reps_for("CA")

def active_legislators(title)
  Legislator.where('title = ? AND in_office = ?', title, true)
end

def print_legislator_gender_stats(gender, title)
  actives = active_legislators(title.capitalize[0..2])
  gender_count = actives.where('gender = ?', gender.capitalize[0]).count
  total_count  = actives.count
  gender_percentage = (gender_count * 100 / total_count)
  puts "#{gender.capitalize} #{title.capitalize}s: " + 
  "#{gender_count} (#{gender_percentage}%)"
end

# print_legislator_gender_stats('male', 'senator')
# print_legislator_gender_stats('female', 'Sen')
# print_legislator_gender_stats('male', 'representative')
# print_legislator_gender_stats('female', 'Rep')

def print_total(title)
  num_legislators = Legislator.where('title LIKE ?', "#{title[0]}%").count
  puts "#{title}s: #{num_legislators}"
end


def print_legislator_counts_by_state
  Legislator.group('state').each do |legislator|
    state = legislator.state
    puts "#{state}: " +
    "#{senators_for(state).count} Senators, " +
    "#{representatives_for(state).count} Representatives"
  end
end

# print_legislator_counts_by_state

def delete_inactives
  Legislator.destroy_all(:in_office => false)
end

# delete_inactives

# print_total('Senator')
# print_total('Representative')
# print_total('Comissioner')
# print_total('Delegate')



