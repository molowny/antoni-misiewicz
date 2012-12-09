# coding: utf-8

require 'rubygems'

# sinatra core
require 'sinatra'
require 'sinatra/contrib'

# i18n
require 'i18n'

# mongodb
# require 'mongo_mapper'

configure do
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'i18n', '*.yml').to_s]

  # MongoMapper.setup(
  #   {
  #     'production' => { 'uri' => ENV['MONGOHQ_URL'] },
  #     'development' => { 'host' => 'localhost', 'database' => 'antos' }
  #   },
  #   ENV['RACK_ENV'] || 'development')
end

configure :development do |config|
  require 'sinatra/reloader'
  config.also_reload 'i18n/*.yml'
end

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

  def t(phrase)
    I18n.t(phrase)
  end

end

# pl
get '/' do
  I18n.locale = :pl

  @active = :about
  haml @active
end

get '/o-mnie' do
  I18n.locale = :pl

  @active = :about
  haml @active
end

get '/apel' do
  I18n.locale = :pl

  @active = :apel
  haml @active
end

get '/kontakt' do
  I18n.locale = :pl

  @active = :contact
  haml @active
end

# en
get '/about-me' do
  I18n.locale = :en

  @active = :about
  haml @active
end

get '/appeal' do
  I18n.locale = :en

  @active = :apel
  haml @active
end

get '/contact' do
  I18n.locale = :en

  @active = :contact
  haml @active
end
