get '/styles/:name.css' do
  content_type :css, :charset => 'utf-8'
  sass :"stylesheets/#{params[:name]}"
end

get '/favicon.ico' do
end

get '/' do
  m = Message.new :zone => request.cookies['timezone']
  @answer, @countdown = m.answer, m.countdown
  @timezones = ['Etc/UTC'] + TZInfo::Timezone.all_country_zone_identifiers.sort
  @current_timezone = request.cookies['timezone']
  haml :index
end

get '/counts.json' do
  content_type :json, :charset => 'utf-8'
  Message.new(:zone => request.cookies['timezone']).to_json
end

post '/timezone' do
  response.set_cookie 'timezone', :value => params[:timezone], :expires => Time.now + (60 * 60 * 24 * 365 * 3)
  redirect '/'
end
