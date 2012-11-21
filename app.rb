require 'httpclient'
require 'sinatra'
require 'yomu'
require 'open-uri'

@@http_client = HTTPClient.new
@@http_client.connect_timeout = 60

get '/extract?*' do
  url = URI::encode(params[:url])
  response = @@http_client.get(url, :follow_redirect => true)
  Timeout::timeout(60) {
    text = safe_squeeze(Yomu.read(:text_main, response.body))
    if text.split.size < 30
      text = safe_squeeze(Yomu.read(:text, response.body))
    end
    return text
  }
end

# Remove superfluous whitespaces from the given string
def safe_squeeze(value)
  value = value.strip.gsub(/\s+/, ' ').squeeze(' ').strip unless value.nil?
end