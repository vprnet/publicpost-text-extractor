require 'httpclient'
require 'yomu'
require 'sinatra'

@@http_client = HTTPClient.new
@@http_client.connect_timeout = 60

get '/extract?*' do
  url = URI::encode(params[:url])
  response = @@http_client.head(url, :follow_redirect => true)
  url = response.http_header.request_uri.to_s
  puts ">>>> Headers for: (#{url}) #{response.headers}"
  text = ""

  if response.content_type.include?("text/html")
    text = Yomu.new(url).text_main
  else
    text = Yomu.new(url).text
  end

  # Sometimes we don't get enough text...
  if text.split(" ").size < 100
    text = Yomu.new(url).text
  end

  return safe_squeeze(text)
end

# Remove superfluous whitespaces from the given string
def safe_squeeze(value)
  value = value.strip.gsub(/\s+/, ' ').squeeze(' ').strip unless value.nil?
end