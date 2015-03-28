require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"  #access to the API

#METHODS SECTION:
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_numbers(phone_number)
  numbers = phone_number.scan(/\d+/).join()  #scan for number only

  if numbers.length != 10
    if numbers.length == 11 && numbers[0] == '1'
      numbers[1..10]  #trim down the number
    else
      numbers = "0000000000"  #00.. as a default for bad numbers
    end
  end
  
  numbers[0..2] + '-' + numbers[3..5] + '-' + numbers[6..9]  #formating return 
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)  #look up legislator by zipcode
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")  #create a new directory if "output" does not exist

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|  #create new file
    file.puts form_letter  
  end
end

def display_peak_hours(hour_counter)
  total = hour_counter.values.inject(0) { |sum, n| sum + n }
  peak_hours = hour_counter.sort_by { |key, value| value }.reverse[0..2].to_h #sort the hash table by value from highest to lowest, take the top 3
  puts "PEAK HOURS"
  puts "-----------"
  peak_hours.each do |hour, counter|
    puts "Hour: #{hour} has #{counter} registers (#{(counter.to_f / total * 100).round(1)})%"
  end
  puts "-----------"
  puts "\n"
end

def display_peak_days(day_counter)
  total = day_counter.values.inject(0) { |sum, n| sum + n }
  peak_days = day_counter.sort_by { |key, value| value }.reverse[0..2].to_h
  puts "PEAK DAYS"
  puts "-----------"
  peak_days.each do |day, counter|
    puts "#{day.to_s.ljust(10, ' ')} has #{counter.to_s.ljust(2, ' ')} registers (#{(counter.to_f / total * 100).round(1)})%"
  end
  puts "-----------"
  puts "\n"
end


#EXECUTION SECTION:
puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol  #open CSV file

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter   #create a new instance for ERB file

hour_counter = Hash.new(0)
day_counter = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phone_numbers(row[:homephone])
  date = row[:regdate]

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)  #execute erb file

  save_thank_you_letters(id, form_letter)  #save erb file

  date_time = DateTime.strptime(date, "%m/%d/%y %H:%M")  #setup the format for date_time

  hour_counter[date_time.hour] += 1
  day_counter[date_time.strftime("%A")] += 1

  puts "Member: #{name} - #{phone} - #{date}"
  puts "\n"

end

display_peak_hours(hour_counter)
display_peak_days(day_counter)

puts "EventManager completed"