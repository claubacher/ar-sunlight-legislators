require 'csv'
require_relative '../app/models/legislator'

class SunlightLegislatorsImporter
  FIELDS = [:title, :firstname, :lastname, :party, :state, :in_office, :gender, :phone, :fax, :website, :webform, :twitter_id, :birthdate] 

  def self.import(filename)
    csv = CSV.new(File.open(filename), :headers => true)
    csv.each do |row|
      attrs = {}
      row.each do |field, value|
        attrs[field.to_sym] = value if FIELDS.include?(field.to_sym)
      end
      Legislator.create!(attrs)
    end
  end
end

# IF YOU WANT TO HAVE THIS FILE RUN ON ITS OWN AND NOT BE IN THE RAKEFILE, UNCOMMENT THE BELOW
# AND RUN THIS FILE FROM THE COMMAND LINE WITH THE PROPER ARGUMENT.
# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end
