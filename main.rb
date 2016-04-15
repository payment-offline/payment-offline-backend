require 'bundler'
Bundler.require

require './config.rb'
require './helpers/database.rb'
require './helpers/pay.rb'

payment = Pay.new

get '/status' do
  JSON.generate ({status:'running'})
end

post '/charge' do
  obj = JSON.parse(request.body.read)
  payment.pay(obj[:money].to_i, obj[:channel], request.ip)
end

