class SinatraDemo < Sinatra::Base
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
    set :public_folder, Proc.new { $servlet_context && !production? ? File.join(settings.root, 'public') : $servlet_context.getRealPath('') }

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

  get '/foo' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  error do
    log_exception

    halt 500
  end

  not_found do
    halt 404
  end
end
