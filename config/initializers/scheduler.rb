require 'rufus-scheduler'

#require "product_sku"
#include ProductSKU




scheduler = Rufus::Scheduler.new
job = scheduler.every '1s' do
puts "hello world"
end
scheduler.join
#   end
# end
