#\ -s trinidad -o 0.0.0.0
require 'bundler'

Bundler.require

require 'logger'
require 'sinatra/reloader' if ENV['RACK_ENV'] == 'development'

Loggr::SLF4J::Jars.require_slf4j_jars! if ENV['RACK_ENV'] == 'production'

require_relative 'app'

run SinatraDemo.new
