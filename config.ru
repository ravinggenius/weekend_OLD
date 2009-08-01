# http://info.michael-simons.eu/2009/07/29/creating-a-self-containing-mvc-application-with-sinatra/
# http://www.modrails.com/documentation/Users%20guide.html
require 'rubygems'
require 'sinatra'

root_dir = File.dirname(__FILE__)

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    File.join(root_dir, 'main.rb')
disable :run

run Sinatra::Application
