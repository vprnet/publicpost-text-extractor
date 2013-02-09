# encoding: UTF-8
require 'cgi'
require 'net/https'
require 'httpclient'
require 'yomu'
require 'sinatra'

get '/extract?*' do
  text = ""

  http_client = HTTPClient.new
  http_client.connect_timeout = 60

  url  = URI::encode(CGI::unescape(params[:url]))
  guid = Digest::MD5.hexdigest(url)

  response = http_client.head(url, :follow_redirect => true)
  filename = "#{settings.root}/downloaded/#{guid}-#{Time.now.to_i}"

  begin
    file = open(filename, 'wb')
    begin
      # Chunk the download out to a temp file so that we keep memory limits low
      http_client.get_content(url) do |chunk|
        file.write(chunk)
      end

      # Extract the text from the document
      yomu = Yomu.new filename
      if response.content_type.include?("text/html")
        text = yomu.text_main
      else
        text = yomu.text
      end

      # Sometimes we don't get enough text...
      if text.split(" ").size < 100
        yomu = Yomu.new filename
        text = yomu.text
      end
    ensure
      file.close
    end
  ensure
    # Clean up the temp file
    File.delete(filename)
  end

  return safe_squeeze(text)
end

# Remove superfluous whitespaces from the given string
def safe_squeeze(value)
  value = value.strip.gsub(/\s+/, ' ').squeeze(' ').strip unless value.nil?
end