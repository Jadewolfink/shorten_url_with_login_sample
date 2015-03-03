enable :sessions

helpers do
  def current_user
    if session[:user_id]
      User.find session[:user_id]
    else
      nil
    end
  end

  def logged_in?
    if current_user
      true
    else
      false
    end
  end
end

before do
  pass if ["/", "/users/sign_up", "/users/login"].include?request.path
  redirect '/' unless logged_in?
end

get '/' do
  erb :index
end

get '/abc/adc/agc' do
  @user = current_user
  erb :urls
end

get '/urls' do
  @user = current_user
  if @user
    @urls = Url.all
    erb :urls
  else
    redirect to '/'
  end
end

post '/urls' do
  @url = Url.create(params[:url])
  redirect to '/urls'
end

# e.g., /q6bda
get '/:short_url' do
  @short_url = params[:short_url]
  @url = Url.where(short_url: @short_url).first
  @url.increment!(:click_count)
  redirect to @url.long_url
end

post '/users/sign_up' do
  @user = User.create(params[:user])
  # @user = User.create(username: params[:username],
   # email: params[:email], password: params[:password])
  session[:user_id] = @user.id
  redirect to '/urls'
end

post '/users/login' do
  @user = User.authenticate(params[:user][:email], params[:user][:password])
  if @user
    session[:user_id] = @user.id
    redirect to '/urls'
  else
    redirect to '/'
  end
end

delete '/logout' do
  session.clear
  redirect to '/'
end

