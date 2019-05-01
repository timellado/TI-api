require 'rufus-scheduler'

#require "product_sku"
#include ProductSKU


if defined?(::Rails::Server)
	puts "Partiendo scheduler"



  job_sftp = Rufus::Scheduler.new(:max_work_threads => 1)
  job_sftp.every '10m', :first_in => 2 do
    ApplicationRecord.clean
		puts "Termina de limpiar"
  end

end



#scheduler = Rufus::Scheduler.new


#scheduler.every '2h',  :first_in => 5 do
 # ApplicationRecord.keep_minimum_stock
#end
#scheduler.join

# scheduler.every '20s' do
#   lista = ProductSKU.get_sku_product()
#   lista.each do |i|
#     p i
#     Logica.sacar_de_despacho(i[0], 200)



# end
