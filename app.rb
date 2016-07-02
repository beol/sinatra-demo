require 'bundler'

Bundler.require

require 'logger'
require 'sinatra/reloader'
require 'loggr/slf4j/jars'

Loggr::SLF4J::Jars.require_slf4j_jars!


configure do
  LoggerFactory.adapter = production? ? :slf4j : :base
  $logger = LoggerFactory.logger('com.laksmana.sinatra.app', to: $stderr, level: Logger::Severity::DEBUG)
  $error_logger = $stderr
end

configure :development do
  register Sinatra::Reloader
end

configure :production do
  set :logging, nil
end

before do
  env['rack.errors'] = $error_logger
  env['rack.logger'] = $logger
end

get '/' do
  logger.debug self.class
  'hello world!'
end
