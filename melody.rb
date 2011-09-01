APP_ROOT = File.dirname(File.expand_path( __FILE__))

$: << "#{APP_ROOT}"

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
#require 'id3lib'
require 'mp3info'
require 'app_config'
require 'json'
require 'track'
require 'app'

