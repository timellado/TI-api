

env :PATH, ENV['PATH']
set :environment, "development"

set :output, "log/cron.log"


every 2.minutes do
    rake "clean"
end

every 15.minutes do
    rake "keep_min_stock"
end

every 5.minutes do
  rake  "obtain_ftp_order"
end

every 20.minutes do
    rake "clean_order_register"
end
