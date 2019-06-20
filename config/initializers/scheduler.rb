require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
scheduler.every '1h10m', :first_in => 60  do
    p "START CLEAN RECEPTION"
    Logica.clean_reception
    p "FINISH CLEAN RECEPTION"
    p "START PEDIR"
    ScheduleStock.pedir_productos_faltantes
    p "FINISH PEDIR"
    p "START CLEAN ORDER REGISTER"
    ScheduleStock.clean_order_register
    p "FINISH ORDER REGISTER"
end




