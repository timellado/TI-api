require 'schedule_stock'
require 'ftp'
include ScheduleStock
include FTP

task :clean do
  ScheduleStock.clean()
  puts Time.now
  puts "--------------------------------Termina de limpiar--------------------------------------"

end

task :keep_min_stock do
  puts "--------------------------------Empieza de pedir--------------------------------------"
  ScheduleStock.keep_minimum_stock()
  puts Time.now
  puts "--------------------------------Termina de pedir--------------------------------------"

end

task :obtain_ftp_order do
  FTP.get_id()
  puts Time.now
  puts "--------------------------------Termina de guardar ordenes ftp--------------------------------------"  
end

task :clean_order_register do
  ScheduleStock.clean_order_register()
  puts Time.now
  puts "--------------------------------Termina clean OrderRegister--------------------------------------"
end
