#irb - 14MB
require 'httpclient' # 24MB
require 'yomu' # 26MB
require 'sinatra' #  28MB

@@http_client = HTTPClient.new  # 28MB
@@http_client.connect_timeout = 60 # 28MB

url =  "http://www.charlottevt.org/vertical/sites/%7B5618C1B5-BAB5-4588-B4CF-330F32AA3E59%7D/uploads/%7BB61C05E0-94E5-49E3-A117-5919C308342F%7D.PDF" # 28MB
response = @@http_client.get(url, :follow_redirect => true) # 28.1MB
text = ""
Timeout::timeout(60) {
  if response.content_type.include?("text/html")
    extraction_method = :text_main
  else
    extraction_method = :text
  end
  text = Yomu.read(extraction_method, response.body)
}