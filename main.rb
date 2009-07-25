# http://earthcode.com/blog/2008/12/building_a_simple_sinatradatam.html
# also check github account for sample apps…

require 'rubygems'
$:.unshift File.join(File.dirname(__FILE__), 'vendor', 'sinatra', 'lib')
require 'sinatra'
require File.join(File.dirname(__FILE__), 'lib', 'weekend_app')
require 'haml'

require 'models/message'

set :public, 'assets'

SITE_TITLE = 'IsItTheWeekendYet?'
SITE_TAGLINE = 'the question on everyone\'s mind'

get '/' do
  m = Message.new
  @title = "#{SITE_TITLE} - #{SITE_TAGLINE}"
  @answer, @comment, @countdown = m.answer, m.comment, m.countdown
  haml :index
end

get '/counts.json' do
  Message.new.to_json
end

get '/about/' do
  @title = "About | #{SITE_TITLE}"
  haml :about
end

post '/timezone/' do
  # set the timezone cookie
  # this will be done in JS if available
  redirect '/'
end

error do
  request.env["sinatra.error"].message
end

not_found do
  #401, 'That URL doesn\'t exists.'
  'That URL doesn\'t exists.'
end
