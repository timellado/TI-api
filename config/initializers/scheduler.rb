require 'rufus-scheduler'
require 'logica'

scheduler = Rufus::Scheduler.new
scheduler.every '1h10m', :first_in => 60  do
    p "START CLEAN RECEPTION"
    p "FINISH CLEAN RECEPTION"
    p "START PEDIR"
    ScheduleStock.pedir_productos_faltantes
    p "FINISH PEDIR"
    p "START CLEAN ORDER REGISTER"
    ScheduleStock.clean_order_register
    p "FINISH ORDER REGISTER"

end 

scheduler2 =  Rufus::Scheduler.new
scheduler2.every '20m' :first_in => 60 do
  p 'OBTENER NUEVOS FTP'
  FTP.get_id
  p 'TERMINO FTP'
  p 'REVISAR SI LLEGARON ROLLS FTP'
  Filter.revisar_ftp
  p 'TERMINO'

end

scheduler3 =  Rufus::Scheduler.new
scheduler3.cron '20 23 * * *' do
  p "START CLEAN PULMON"
  Logica.clean_pulmon
  p 'FINISH CLEAN PULMON'
 
end