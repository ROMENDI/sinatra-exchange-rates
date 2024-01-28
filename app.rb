# /app.rb

require "sinatra"
require "sinatra/reloader"
require "http"

# define a route
get("/") do
  api_url = "http://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATES_KEY"]}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  currencies= parsed_data["currencies"]
  @symbols = currencies.keys

  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params["from_currency"]

  api_url = "http://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATES_KEY"]}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  currencies= parsed_data["currencies"]
  @symbols = currencies.keys

  erb(:currency_page)
end

  get("/:from_currency/:to_currency") do
    @original_currency = params["from_currency"]
    @destination_currency = params["to_currency"]
  
    api_url = "http://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATES_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
    raw_data = HTTP.get(api_url)
    raw_data_string = raw_data.to_s
    parsed_data = JSON.parse(raw_data_string)
    @conversion_value = parsed_data["result"]
    
    erb(:conversion_page)
end
