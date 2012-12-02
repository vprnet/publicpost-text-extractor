require 'httpclient'
require 'sinatra'
require 'yomu'

@@http_client = HTTPClient.new
@@http_client.connect_timeout = 60

get '/extract?*' do
  url = params[:url]
  response = @@http_client.get(url, :follow_redirect => true)
  text = ""

  Timeout::timeout(60) {
    if response.content_type.include?("text/html")
      extraction_method = :text_main
    else
      extraction_method = :text
    end
    text = safe_squeeze(Yomu.read(extraction_method, response.body))
  }
  return text
end

# Remove superfluous whitespaces from the given string
def safe_squeeze(value)
  value = value.strip.gsub(/\s+/, ' ').squeeze(' ').strip unless value.nil?
end