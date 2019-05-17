# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
env :PATH, ENV['PATH']
set :environment, "development"
#set :output, "/log/cron_log.log"

set :output, "log/cron.log"


every 2.minutes do
#   command "/usr/bin/some_great_command"
   #runner "Order.min_stock"
   rake "scheduler"
#   rake "some:great:rake:task"
 end



#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
