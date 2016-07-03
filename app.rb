Bundler.require

require 'logger'
require 'sinatra/reloader'
require 'loggr/slf4j/jars'

Loggr::SLF4J::Jars.require_slf4j_jars!

class SinatraDemo < Sinatra::Base
  configure do
    enable :dump_errors

    LoggerFactory.adapter = production? ? :slf4j : :base
    $logger = LoggerFactory.logger('com.laksmana.sinatra.app', to: $stderr, level: Logger::Severity::DEBUG)
    $error_logger = $stderr

    if $servlet_context
      set :config, Proc.new { $servlet_context.getInitParameter('configRoot') }
    else
      set :config, Proc.new { File.expand_path('../config', __FILE__) }
    end
  end

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    set :logging, nil
  end

  before do
    env['rack.logger'] = $logger
    env['rack.errors'] = $error_logger
  end

  get '/' do
    logger.info settings.config
    logger.debug self.class
    logger.debug $servlet_context.getInitParameter('foo') if $servlet_context
    logger.debug $servlet_context.getServerInfo() if $servlet_context
    raise
    'hello world!'
  end
end

