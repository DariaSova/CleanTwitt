require 'sinatra' 
require 'oauth'
require 'twitter'
require 'pry'

get '/' do 
  haml :welcome
end

get '/login' do
  @callback_url = "http://localhost:4567/oauth/twitter/callback"
  @consumer = OAuth::Consumer.new("4QYCvDdOhBZTiaqLH3kv4LvAW","nBX51piLcNMn64QGoRdnbP6RS8sSsOvQYt9wSyTzWfYX36nx9G", :site => "https://api.twitter.com")
  @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
  session[:token] = @request_token.token
  session[:token_secret] = @request_token.secret
  redirect @request_token.authorize_url(:oauth_callback => @callback_url)


  #client = Twitter::REST::Client.new do |config|
  #  config.consumer_key        = "4QYCvDdOhBZTiaqLH3kv4LvAW"
  #  config.consumer_secret     = "nBX51piLcNMn64QGoRdnbP6RS8sSsOvQYt9wSyTzWfYX36nx9G"
  #  config.access_token        = request_token.token
  #  config.access_token_secret = request_token.secret
  #end
  #binding.pry
  #client.update('Tweeting with OAuth access!')
end

get '/oauth/twitter/callback' do 
  "CAllback REcieved!!"
  hash = { oauth_token: params[:oauth_token], oauth_token_secret: params[:oauth_verifier]}
  @consumer = OAuth::Consumer.new("4QYCvDdOhBZTiaqLH3kv4LvAW","nBX51piLcNMn64QGoRdnbP6RS8sSsOvQYt9wSyTzWfYX36nx9G", :site => "https://api.twitter.com")
  request_token  = OAuth::RequestToken.from_hash(@consumer, hash)
  @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
end

#private
#
#def get_consumer
#  OAuth::Consumer.new(
#    YOUR_CONSUMER_KEY, 
#    YOUR_CONSUMER_SECRET, 
#    {:site => 'http://twitter.com'}
#  )
#end
