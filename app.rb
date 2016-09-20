require 'sinatra' 

get '/' do 
  haml :welcome
end
