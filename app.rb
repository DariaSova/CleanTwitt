require 'sinatra' 
require 'oauth'
require 'twitter'
require_relative 'config'
require 'pry'

CALLBACK_URL = "http://localhost:4567/oauth/twitter/callback"


get '/' do 
  haml :welcome
end

get '/login' do
  @callback_url = CALLBACK_URL
  @consumer = get_consumer
  @request_token = @consumer.get_request_token(oauth_callback: @callback_url)
  session[:token] = @request_token.token
  session[:token_secret] = @request_token.secret
  redirect @request_token.authorize_url(oauth_callback: @callback_url)
end

get '/oauth/twitter/callback' do 
  hash = { oauth_token: params[:oauth_token], oauth_token_secret: params[:oauth_verifier]}
  @consumer = get_consumer
  request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
  @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
  @client = get_client
  #@client.update('Hola!')
  redirect '/menu'
end

get '/menu' do
  haml :clean_tweets
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
