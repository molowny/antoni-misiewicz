# coding: utf-8

require 'rubygems'

# sinatra core
require 'sinatra'
require 'sinatra/contrib'

require 'sinatra/reloader' if development?

# i18n

# mongodb
# require 'mongo_mapper'

# configure do
#   MongoMapper.setup(
#     {
#       'production' => { 'uri' => ENV['MONGOHQ_URL'] },
#       'development' => { 'host' => 'localhost', 'database' => 'antos' }
#     },
#     ENV['RACK_ENV'] || 'development')
# end

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Podaj haslo dostepowe")
      throw :halt, [401, "Nie masz dostepu do tej strony\n"]
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end

end

get '/' do
  @active = :about
  haml @active
end

get '/o-mnie' do
  @active = :about
  haml @active
end

get '/apel' do
  @active = :apel
  haml @active
end