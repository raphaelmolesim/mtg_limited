require "./console"

set = "Outlaws of Thunder Junction".downcase
set_abbreviation = "OTJ"
search_string = "limited set review #{set}"


console = ConsoleApp.new

puts " ## Welcome to the MTG Limited Review App ##"
puts " -> What do you want to do?"

puts " 1) Download limited reviews for a specific set"
puts " 2) Update card database"

input = gets.chomp

if input == "1"
  console.download_data
end

if input == "2"
  console.update_database
end

puts "==> Exiting..."