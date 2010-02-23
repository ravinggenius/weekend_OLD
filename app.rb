require 'boot'

require 'compass'
require 'sinatra'
require 'haml'

require 'models/message'

configure do
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :haml, { :format => :html5, :attr_wrapper => '"' }

  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views/stylesheets'
  end

  set :sass, Compass.sass_engine_options
end

SITE_TITLE = 'IsItTheWeekendYet?'
SITE_TAGLINE = 'the question on everyone\'s mind'

get '/styles/:name.css' do
  content_type :css, :charset => 'utf-8'
  sass :"stylesheets/#{params[:name]}"
end

get '/' do
  m = Message.new
  @title = "#{SITE_TITLE} - #{SITE_TAGLINE}"
  @answer, @comment, @countdown = m.answer, m.comment, m.countdown
  haml :index
end

get '/counts.json' do
  content_type :json, :charset => 'utf-8'
  Message.new.to_json
end

post '/timezone' do
  # TODO set the timezone cookie
  # this should be done in JS if available
  redirect '/'
end
