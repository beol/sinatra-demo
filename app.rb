class SinatraDemo < Sinatra::Base
  def app_logger
    @app_logger ||= ::LoggerFactory.logger('com.laksmana.' + self.class.name, 
                                           to: File.join(settings.root, 'log', 'application.log'), 
                                           level: settings.development? ? ::Loggr::Severity::DEBUG : ::Loggr::Severity::INFO) 
  end

  alias_method :logger, :app_logger

  configure do
    disable :dump_errors
    enable :static
    set :logging, nil

    ::LoggerFactory.adapter = production? ? :slf4j : :base

    if $servlet_context
      set :config, Proc.new { $servlet_context.getInitParameter('configRoot') }
    else
      set :config, Proc.new { File.join(settings.root, 'config') }
    end
  end

  configure :development do
    register Sinatra::Reloader

    enable :logging
  end

  get '/hello' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  not_found do
    send_file File.join(settings.public_folder, '404.html'), { status: 404 }
  end

  error do
    e = env['sinatra.error']

    logger.error "#{e.class} - #{e.message}"
    e.backtrace.each { |line| logger.error line } if e.respond_to?(:backtrace)

    send_file File.join(settings.public_folder, '500.html'), { status: 500 }
  end
end
