require 'rufus-scheduler'

#require "product_sku"
#include ProductSKU


scheduler = Rufus::Scheduler.new


scheduler.every '2h',  :first_in => 5 do
  ApplicationRecord.keep_minimum_stock
end
scheduler.join

# scheduler.every '20s' do
#   lista = ProductSKU.get_sku_product()
#   lista.each do |i|
#     p i
#     Logica.sacar_de_despacho(i[0], 200)
scheduler2 = Rufus::Scheduler.new
scheduler2.every '20m', :first_in => 2 do
  ApplicationRecord.clean
end
scheduler2.join


# end
