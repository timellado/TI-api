

env :PATH, ENV['PATH']
set :environment, "development"

set :output, "log/cron.log"


every 5.minutes do
    rake "clean"
end

every 17.minutes do
    rake "keep_min_stock"
end

#every 10.minutes do
#  rake  "obtain_ftp_order"
#end

every 23.minutes do
    rake "clean_order_register"
end

#every 13.minutes do
#    rake "filtrar_ftp"
#end
