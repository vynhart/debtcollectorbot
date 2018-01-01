require 'pry'
require 'dotenv'
require 'logger'
require 'sinatra'
require 'sinatra/activerecord'

Dotenv.load

Dir.glob(File.join('lib/**/*.rb')).each { |file| require_relative file }
Dir.glob(File.join('modules/**/*.rb')).each { |file| require_relative file }
Dir.glob(File.join('models/**/*.rb')).each { |file| require_relative file }
Dir.glob(File.join('services/**/*.rb')).each { |file| require_relative file }

HOOK_TOKEN = 't3lEGr4mh0Ock3d'
Log = Logger.new('log/hook_params.log', 10, 1_048_576)

class App < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/' do
    'Hi there'
  end

  post "/#{HOOK_TOKEN}" do
    Log.info("params: #{params}")
    body = request.body.read
    Log.info("body: #{body}")

    ::TelegramService.new(body).process
  end
end

if __FILE__ == $0
  App.run!
end
