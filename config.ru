require './app'
use Rack::Deflater
FileUtils.mkdir_p("#{settings.root}/downloaded")
run Sinatra::Application