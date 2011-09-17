require './boot'

Dir[Dir.pwd + '/lib/*.rb'].each { |file| require file }

configure do
  set :app_file, __FILE__
  set :root, Dir.pwd
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

  def partial(name, locals = {}, options = {})
    options[:layout] = nil
    options[:locals] ||= {}
    options[:locals].merge! locals
    begin
      haml name.to_sym, options
    rescue
      haml "shared/#{name}".to_sym, options
    end
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

require './routes'
