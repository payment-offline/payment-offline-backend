require 'bundler'
Bundler.require

require './config.rb'
require './helpers/database.rb'
require './helpers/pay.rb'

configure {set :server, :puma}
Faye::WebSocket.load_adapter('puma')
order_socket_pair = {test: 'hello'}

payment = Pay.new

get '/status' do
  JSON.generate ({status:'running'})
end

post '/charge/succeeded' do
  obj = JSON.parse(request.body.read)
  order_no = obj['data']['order_no']
  order_socket_pair[order_no].send JSON.generate({status: 'charged'})
  'ok'
end

post '/charge' do
  obj = JSON.parse(request.body.read)
  payment.pay(obj['money'].to_i, obj['channel'], request.ip)
end

get '/waiting/:order_id' do |order_id|
  ws = Faye::WebSocket.new(request.env)

  ws.on :open do
    order_socket_pair[order_id] = ws
  end

  ws.on :close do
    order_socket_pair.delete(ws)
  end
end