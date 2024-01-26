# /app.rb

require "sinatra"
require "sinatra/reloader"
require "http"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATES_KEY"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
   @symbols = parsed_data["symbols"].keys

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency").upcase
  api_url = "https://api.exchangerate.host/latest?access_key=#{ENV['EXCHANGE_RATES_KEY']}&base=#{@original_currency}"
  response = HTTP.get(api_url).to_s
  parsed_data = JSON.parse(response)
  @rates = parsed_data["rates"]
  erb(:currency_page)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency").upcase
  @destination_currency = params.fetch("to_currency").upcase
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_RATES_KEY']}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  response = HTTP.get(api_url).to_s
  parsed_data = JSON.parse(response)
  @conversion_rate = parsed_data["result"]
  erb(:conversion_page)
end
