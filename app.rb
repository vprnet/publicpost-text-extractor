# encoding: UTF-8
require 'net/https'
require 'httpclient'
require 'yomu'
require 'sinatra'

get '/extract?*' do
  begin
    text = ""

    http_client = HTTPClient.new
    http_client.connect_timeout = 60

    url = URI::encode(params[:url])
    response = http_client.head(url, :follow_redirect => true)
    guid = Digest::MD5.hexdigest(url)
    filename = "#{settings.root}/downloaded/#{guid}-#{Time.now.to_i}"
    file = open(filename, 'wb')

    # Chunk the download out to a temp file so that we keep memory limits low
    begin
      http_client.get_content(url, :follow_redirect => true) do |chunk|
        file.write(chunk)
      end
    ensure
      file.close
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
    # Clean up the temp file
    File.delete(filename)

    #httpclient = nil
  end

  return safe_squeeze(text)
end

# Remove superfluous whitespaces from the given string
def safe_squeeze(value)
  value = value.strip.gsub(/\s+/, ' ').squeeze(' ').strip unless value.nil?
end