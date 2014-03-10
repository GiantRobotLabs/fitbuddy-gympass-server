require 'rubygems'
require 'bundler'
Bundler.require

require "#{ENV['OPENSHIFT_DATA_DIR']}/private/local_config.rb"

require './app.rb'

run Sinatra::Application
