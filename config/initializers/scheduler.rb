require 'rufus-scheduler'

#require "product_sku"
#include ProductSKU




scheduler = Rufus::Scheduler.start_new
job = scheduler.every '1s' do
puts "hello world"
end
scheduler.start
#   end
# end
