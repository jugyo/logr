# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'fileutils'

CONFIG = YAML.load_file('config.yml')
set :sessions, true
use Rack::Session::Cookie, CONFIG["session"]

$:.unshift(File.dirname(__FILE__))
Dir['lib/*'].each do |file|
  load file
end

Dir.mkdir('entries') unless File.exists?('entries')

get '/' do
  @entries = entries(0)
  haml :entries
end

post '/' do
  # TODO: create a entry
  redirect '/'
end

get '/:id' do
  @entry = entry(params[:id])
  if @entry
    haml :entry
  else
    halt 404
  end
end

get '/page/:num' do
  @entries = entries(params[:num])
  haml :entries
end
