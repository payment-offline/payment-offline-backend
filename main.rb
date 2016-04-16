require 'bundler'
Bundler.require

require './config.rb'
require './helpers/database.rb'
require './helpers/pay.rb'

module JSON
  def self.parse_nil(json)
    JSON.parse(json) if json && json.length >= 2
  end
end

configure {set :server, :puma}
Faye::WebSocket.load_adapter('puma')
order_socket_pair = {}

payment = Pay.new

get '/status' do
  JSON.generate ({status:'running'})
end

post '/charge/succeeded' do
  obj = request.body.read
  order_no = /"order_no": "(.*?)"/.match(obj)[0]
  order_socket_pair[order_no].send(JSON.generate({status: 'charged'}))
  'ok'
end

post '/charge' do
  obj = JSON.parse(request.body.read)
  payment.pay(obj['money'].to_i, obj['channel'], request.ip)
end

get '/waiting/:order_id' do |order_id|
  ws = Faye::WebSocket.new(request.env)

  ws.on :open do |event|
    order_socket_pair[order_id] = ws
    ws.send(JSON.generate({stats: 'connected'}))
  end

  ws.on :close do |event|
    order_socket_pair.delete(ws)
  end

  ws.rack_response
end