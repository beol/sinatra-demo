require_relative 'application_controller'

class SinatraDemo < ApplicationController
  get '/' do
    send_file File.join(settings.public_folder, 'foo.html')
  end
end
