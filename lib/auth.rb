get '/login' do
  unless logged_in?
    haml :login
  else
    redirect '/'
  end
end

post '/login' do
  if params[:login] == CONFIG["login"] && params[:password] == CONFIG["password"]
    session[:user] = params[:login]
    redirect '/'
  else
    halt 403
  end
end

get '/logout' do
  login_required
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
