require 'schedule_stock'

include ScheduleStock

task :clean do
  ScheduleStock.clean()
  puts Time.now
  puts "--------------------------------Termina de limpiar--------------------------------------"
  
end

task :keep_min_stock do
  ScheduleStock.keep_minimum_stock()
  puts Time.now
  puts "--------------------------------Termina de pedir--------------------------------------"
  
end

task :clean_order_register do
  ScheduleStock.clean_order_register()
  puts Time.now
  puts "--------------------------------Termina clean OrderRegister--------------------------------------"
  
end
