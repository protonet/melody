APP_ROOT = File.dirname(File.expand_path( __FILE__))

$: << "#{APP_ROOT}"

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'id3lib'
require 'data_mapper'
require 'db'
require 'app_config'
require 'track'
require 'app'