require 'rufus-scheduler'
require "logica"
require "product_sku"
include Logica
include ProductSKU
scheduler = Rufus::Scheduler.new

scheduler.every '2h' do
  ApplicationRecord.keep_minimum_stock
end

# scheduler.every '20s' do
#   lista = ProductSKU.get_sku_product()
#   lista.each do |i|
#     p i
#     Logica.sacar_de_despacho(i[0], 200)
#   end
# end
