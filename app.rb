# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'json'
require 'fileutils'

# config

BASE_DIR = File.dirname(__FILE__)
CONFIG = YAML.load_file(BASE_DIR + '/config.yml')
set :views, BASE_DIR + '/themes/' + CONFIG["theme"]
set :sessions, true
use Rack::Session::Cookie, CONFIG["session"]

# load libs

$:.unshift(BASE_DIR)
Dir['lib/*'].each { |file| load file }

# routing

get '/css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :css
end

get '/' do
  @page = 0
  @entries = Entry.keys.reverse[0...CONFIG["par_page"]].map { |key| Entry[key] }
  haml :entries
end

get '/entries/new' do
  login_required
  @entry = {}
  haml :new
end

post '/entries/create' do
  login_required
  key = Entry << params.symbolize_keys
  if request.xhr?
    partial :entry, :locals => {:entry => Entry[key]}
  else
    redirect "/entries/#{key}"
  end
end

get '/entries/:key/edit' do
  login_required
  @entry = Entry[params[:key]]
  if @entry
    haml :edit
  else
    halt 404
  end
end

post '/entries/:key/update' do
  login_required
  if Entry.exists?(params[:key])
    Entry[params[:key]] = params.symbolize_keys
    redirect "/entries/#{params[:key]}/edit"
  else
    halt 403
  end
end

get '/entries/:key/delete' do
  login_required
  Entry.delete(params[:key])
  redirect "/"
end

get '/entries/:key' do
  @entry = Entry[params[:key]]
  if @entry
    haml :entry
  else
    halt 404
  end
end

get '/page/:page' do
  @page = params[:page].to_i
  from = CONFIG["par_page"] * @page
  to = from + CONFIG["par_page"]
  @entries = Entry.keys.reverse[from...to].map { |key| Entry[key] } rescue []
  haml :entries
end
