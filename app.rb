require 'sinatra'
require 'oauth'
require 'twitter'
require_relative 'config'
require 'pry'

get '/' do
  haml :welcome
end

get '/login' do
  @callback_url = "http://localhost:4567/oauth/twitter/callback"
  @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, site: "https://api.twitter.com")
  @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
  session[:token] = @request_token.token
  session[:token_secret] = @request_token.secret
  redirect @request_token.authorize_url(:oauth_callback => @callback_url)
end

get '/oauth/twitter/callback' do
  "CAllback REcieved!!"
  hash = { oauth_token: params[:oauth_token], oauth_token_secret: params[:oauth_verifier]}
  @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, site: "https://api.twitter.com")
  request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
  @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONSUMER_KEY
    config.consumer_secret     = CONSUMER_SECRET
    config.access_token        = @access_token.token
    config.access_token_secret = @access_token.secret
  end
  #tweet from user's account
  @client.update('Hola!')
  "Woohoo! it works!"
end
