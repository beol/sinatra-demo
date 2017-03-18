class ApplicationController < Sinatra::Base
  def app_logger
    @app_logger ||= ::LoggerFactory.logger("com.laksmana.#{self.class.name}", 
                                           to: $stderr,
                                           level: ::Loggr::Severity::DEBUG) 
  end

  alias_method :logger, :app_logger

  def log_exception
    e = env['sinatra.error']

    unless e.nil?
      logger.error "#{e.class} - #{e.message}"
      e.backtrace.each { |line| logger.error line } if e.respond_to?(:backtrace)
    end
  end

  configure do
    enable :dump_errors
    enable :static
    set :root, Proc.new { File.expand_path('../..', __FILE__) }

    set :logging, nil

    ::LoggerFactory.adapter = production? ? :slf4j : :base

    set :config, Proc.new { $servlet_context ? $servlet_context.getInitParameter('configRoot') : File.join(settings.root, 'config') }
  end

  configure :development do
    enable :logging
  end

  before do
    logger.debug "\n#{request.to_yaml}"
  end

  error do
    log_exception

    send_file File.join(settings.public_folder, '500.html'), status: 500
  end

  not_found do
    send_file File.join(settings.public_folder, '404.html'), status: 404
  end
end
