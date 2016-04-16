require 'securerandom'

class Pay
  def initialize
    Pingpp.api_key = Config.api_key
  end

  def pay(money, channel, ip)
    order_no = SecureRandom.hex
    charge = Pingpp::Charge.create(
                      :order_no => order_no,
                      :amount => money,
                      :subject => 'Your Subject',
                      :body => 'Your Body',
                      :channel => channel,
                      :currency => 'cny',
                      :client_ip => ip,
                      :app => {:id => Config.api_id}
    )
    JSON.generate(charge)
  end
end