# Write your soltuion here!
require "http"
require "json"
require "dotenv/load"

gmaps_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER")
precipitation_min = 0.10

puts "Let us see if you will need an umbrella today"
puts "What City are you in?"
city = gets.chomp
#city = "Marana"

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{city}&key=#{gmaps_key}"

response = HTTP.get(gmaps_url)
json_response = JSON.parse(response)
results = json_response.fetch("results")
first_array = results.at(0)
geometry = first_array.fetch("geometry")
location = geometry.fetch("location")
latitude = location.fetch("lat")
longitude = location.fetch("lng")

puts "Getting weather data for #{latitude}, #{longitude}."

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

pirate_response = HTTP.get(pirate_weather_url)
pirate_json = JSON.parse(pirate_response)
# pp pirate_json
# pp pirate_json.keys
current_weather = pirate_json.fetch("currently")
# pp current_weather
current_temp = current_weather.fetch("temperature")
if current_temp.to_i < 32
  puts "You might need a coat it's cold out at #{current_temp} degrees F"
elsif current_temp.to_i < 55
  puts "You might want a light jacket it's chilly out at #{current_temp} degrees F"
end
summary = current_weather.fetch("summary")

puts "The weather currently is #{summary}"
if summary.downcase.include? "rain"
  puts "You might need a Umbrella"
end
