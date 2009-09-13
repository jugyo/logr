# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
$:.unshift(File.dirname(__FILE__))
set YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
set :sessions, true

load 'lib/auth.rb'

get '/' do
  current_user
end

get '/entries' do
  login_required
  'entries...'
end
