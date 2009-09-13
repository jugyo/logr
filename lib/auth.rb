get '/login' do
  haml :login
end

post '/login' do
  if params[:login] == options.login && params[:password] == options.password
    session[:user] = params[:login]
    redirect '/'
  else
    halt 403
  end
end

get '/logout' do
  session.delete(:user)
  redirect '/'
end

helpers do
  def current_user
    session[:user]
  end

  def logged_in?
    !!current_user
  end

  def login_required
    unless logged_in?
      halt 403
    end
  end
end
