require 'rufus-scheduler'

#require "product_sku"
#include ProductSKU

require 'logica'

include Logica

scheduler = Rufus::Scheduler.new

scheduler.every '2h', :first_in => 2 do
  ApplicationRecord.keep_minimum_stock
end


# scheduler.every '20s' do
#   lista = ProductSKU.get_sku_product()
#   lista.each do |i|
#     p i
#     Logica.sacar_de_despacho(i[0], 200)

scheduler.every '1h', :first_in => 2 do
  Logica.clean_reception
end

#   end
# end
