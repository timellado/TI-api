require 'rufus-scheduler'
require 'logica'

include Logica

scheduler = Rufus::Scheduler.new

scheduler.every '2h', :first_in => 2 do
  ApplicationRecord.keep_minimum_stock
end

scheduler.every '1h' do
  Logica.clean_reception
end

# scheduler.every '5s' do
#   producto = Product.find_by_sku("1007")
#   #Pedir a otros grupos
#   groups = producto.groups
#   groups_id = groups.map{|m| m.id()}
#   groups_id.each do |g|
#     p g
#   end
# end
