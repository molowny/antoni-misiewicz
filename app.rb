# coding: utf-8

require 'rubygems'

# sinatra core
require 'sinatra'
require 'sinatra/contrib'

# i18n
require 'i18n'

# mails
require 'pony'

# mongodb
require 'mongo_mapper'

# models
class Post
  include MongoMapper::Document

  key :title,   String, required: true
  key :content, String, required: true
  timestamps!
end

configure do
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'i18n', '*.yml').to_s]

  MongoMapper.setup(
    {
      'production' => { 'uri' => ENV['MONGOHQ_URL'] },
      'development' => { 'host' => 'localhost', 'database' => 'antos' }
    },
    ENV['RACK_ENV'] || 'development')
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
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', ENV['HTTP_PASSWORD']]
  end

  def t(phrase)
    I18n.t(phrase)
  end
end

namespace '/' do
  before { I18n.locale = :pl }

  get { haml @active = :about }
  get('o-mnie') { haml @active = :about }
  get('apel') { haml @active = :apel }
  get('kontakt') { haml @active = :contact }
  get('polityka-prywatnosci') { haml @active = :policy }
end

namespace '/en/' do
  before { I18n.locale = :en }

  get('about-me') { haml @active = :about }
  get('appeal') { haml @active = :apel }
  get('contact') { haml @active = :contact }
end

post '/send_message' do
  @name = Rack::Utils.escape_html(params[:name])
  @email = Rack::Utils.escape_html(params[:email])
  @message = Rack::Utils.escape_html(params[:message])

  Pony.mail({
    to: 'kontakt@antonimisiewicz.pl',
    from: @email,
    subject: 'Wiadomość z formularza kontaktowego',
    html_body: haml(:mail, layout: false),
    via: :smtp,
    via_options: {
      address:              'smtp.gmail.com',
      port:                 '587',
      enable_starttls_auto: true,
      user_name:            'kontakt@antonimisiewicz.pl',
      password:             ENV['EMAIL_PASSWORD'],
      authentication:       :plain
    }
  })
end

get '/admin' do
  protected!
  redirect '/'
end

# blog entries
namespace '/blog/' do
  get 'posts' do
    I18n.locale = :pl

    @posts = Post.all(order: :created_at.desc)
    @months = @posts.group_by { |t| t.created_at.strftime('%B %Y') }

    @post = Post.new

    haml @active = :posts
  end

  # blog
  post 'posts' do
    protected!

    @posts = Post.all(order: :created_at.desc)
    @post = Post.new(title: params[:title], content: params[:content])

    if @post.save
      redirect '/blog/posts'
    else
      haml :posts
    end
  end

  get 'posts/:id/destroy' do
    protected!

    post = Post.find(params[:id])
    post.destroy

    redirect '/blog/posts'
  end
end
