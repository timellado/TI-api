require 'inventory'
class ShopController < ApplicationController
  include Inventory
  def index

  end

  def products
    @products = Inventory.get_inventory_for_group
    @cart = []
  end

  def checkout
  end


end
