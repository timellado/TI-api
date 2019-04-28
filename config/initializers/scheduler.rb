require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '20s' do
  ApplicationRecord.keep_minimum_stock
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
