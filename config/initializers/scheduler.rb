require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h30m', :first_in => 60  do
    Logica.clean_reception
    ScheduleStock.pedir_productos_faltantes
    ScheduleStock.clean_order_register
end




