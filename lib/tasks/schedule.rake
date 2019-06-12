require 'schedule_stock'
require 'ftp'
require 'filter'
include ScheduleStock
include FTP
include Filter

task :clean do
  ScheduleStock.clean()
  puts Time.now
  puts "--------------------------------Termina de limpiar--------------------------------------"

end

task :keep_min_stock do
  puts "--------------------------------Empieza mantener minimo stock--------------------------------------"
  ScheduleStock.keep_minimum_stock()
  puts Time.now
  puts "--------------------------------Termina mantener minimo stock--------------------------------------"

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

task :filtrar_ftp do
  Filter.revisar_ftp()
  puts Time.now
  puts "--------------------------------Termina filtrar ftp--------------------------------------"
end
