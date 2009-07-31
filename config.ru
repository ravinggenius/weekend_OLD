# http://info.michael-simons.eu/2009/07/29/creating-a-self-containing-mvc-application-with-sinatra/
# To use with thin 
#thin start -p PORT -R config.ru

require File.join(File.dirname(__FILE__), 'weekend_app.rb')

disable :run
set :env, :production
run Sinatra.application
