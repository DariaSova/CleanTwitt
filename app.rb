require 'sinatra'
require 'sinatra/base'
require 'oauth'
require 'twitter'
require_relative 'config'
require_relative 'lib/cleantwit_app'
require 'pry'


class Application < Sinatra::Base
  CALLBACK_URL = "http://localhost:4567/oauth/twitter/callback"
  set :cleanTwit, nil

  get '/' do
    haml :welcome
  end

  get '/login' do
    @consumer = get_consumer
    @request_token = @consumer.get_request_token(oauth_callback: CALLBACK_URL)
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect @request_token.authorize_url(oauth_callback: @callback_url)
  end

  get '/oauth/twitter/callback' do
    hash = { oauth_token: params[:oauth_token], oauth_token_secret: params[:oauth_verifier]}
    @consumer = get_consumer
    request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
    @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    settings.cleanTwit = CleanTwitApp.new(get_client)
    redirect '/menu'
  end

  get '/menu' do
    haml :clean_tweets
  end

  get '/destroy_all_tweets' do
    settings.cleanTwit.delete_all_tweets
    redirect '/menu'
  end

  private
  def get_consumer
    OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, site: "https://api.twitter.com")
  end

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = CONSUMER_KEY
      config.consumer_secret     = CONSUMER_SECRET
      config.access_token        = @access_token.token
      config.access_token_secret = @access_token.secret
    end
  end
end

Application.run!
