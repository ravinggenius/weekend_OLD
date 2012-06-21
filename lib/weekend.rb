ENV['BUNDLE_GEMFILE'] ||= File.expand_path('./Gemfile')

if File.exists?(ENV['BUNDLE_GEMFILE'])
  require 'bundler'

  Bundler.require
end

require_relative 'weekend/message'
require_relative 'weekend/message_presenter'

class Weekend < Sinatra::Base
  configure do
    set :app_file, __FILE__
    set :root, File.dirname(__FILE__)
    set :haml, { :format => :xhtml, :attr_wrapper => '"' }

    Compass.configuration do |config|
      config.project_path = Dir.pwd
      config.sass_dir = 'views/stylesheets'
    end

    set :sass, Compass.sass_engine_options
  end

  helpers do
    include Rack::Utils

    alias_method :h, :escape_html

    def partial(name, locals = {})
      parts = name.split '/'
      last = parts.last
      last.insert 0, '_' unless last.start_with? '_'
      file = parts.join '/'
      haml file.to_sym, :locals => locals
    end
  end

  before do
    rpath = request.path[1..-1]
    @page_classes = { :class => rpath.blank? ? :index : rpath }

    @site_name = 'IsItTheWeekendYet?'
    @site_tagline = 'the question on everyone\'s mind'

    words = request.path
    words = words.gsub File.extname(words), ''
    words = words.sub '/', ''
    words = words.split('/').map { |s| s.capitalize }.compact.join ': '
    words = words.split('_').map { |s| s.capitalize }.compact.join ' '

    @page_title = words.empty? ? 'Home' : words
    @title = [@page_title, @site_name, @site_tagline].reject(&:empty?)[0..1].join ' - '

    @menu = [
      { :href => '/', :text => 'Home' }
    ].map do |item|
      item[:is_current] = item[:href] == request.path
      item
    end
  end

  get '/styles/:name.css' do
    content_type :css, :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}"
  end

  get '/favicon.ico' do
  end

  get '/' do
    m = Message.new :zone => request.cookies['timezone']
    @answer, @countdown = m.answer, m.countdown
    @answer_class = "answer-#{m.answer.downcase}"
    @timezones = ['Etc/UTC'] + TZInfo::Timezone.all_country_zone_identifiers.sort
    @current_timezone = request.cookies['timezone']
    haml :index
  end

  get '/counts.json' do
    content_type :json, :charset => 'utf-8'
    MessagePresenter.new(Message.new(:zone => request.cookies['timezone'])).to_json
  end

  post '/timezone' do
    response.set_cookie 'timezone', :value => params[:timezone], :expires => Time.now + (60 * 60 * 24 * 365 * 3)
    redirect '/'
  end
end
