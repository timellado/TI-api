require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '2h' do
  ApplicationRecord.keep_minimum_stock
end

# scheduler.every '5s' do
#   p "hola"
# end
