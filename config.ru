#\ -s trinidad -o 0.0.0.0
require 'bundler'
require 'yaml'

Bundler.require

if ENV['RACK_ENV'] == 'production'
  require 'loggr/slf4j/jars'
  Loggr::SLF4J::Jars.require_slf4j_jars!
end

Dir["#{File.expand_path('..', __FILE__)}/{helpers,controllers}/*.rb"].each { |file| require file }

map('/') { run SinatraDemo }
