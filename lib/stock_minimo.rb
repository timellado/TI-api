module StockMinimo
  def self.get_minimum_stock
    minimum_stock_list = [[1301, 50], [1201, 250], [1209, 20], [1109, 50], [1309, 170], [1106, 400], [1114, 50], [1215, 20], [1115, 30], [1105, 50], [1013, 300], [1216, 50], [1116, 250], [1110, 80], [1310, 20], [1210, 150], [1112, 130], [1108, 10], [1407, 40], [1207, 20], [1107, 50], [1307, 170], [1211, 60]]
    return minimum_stock_list
  end

  def self.get_minimum_stock_dic
    minimum_stock_list = {"1301" => 50, "1201" => 250, "1209" => 20, "1109" => 50, "1309" => 170, "1106" => 400, "1114" => 50, "1215" => 20, "1115" => 30, "1105" => 50, "1013" => 300, "1216" => 50, "1116" => 250, "1110" => 80, "1310" => 20, "1210" => 150, "1112" => 130, "1108" => 10, "1407" => 40, "1207" => 20, "1107" => 50, "1307" => 170, "1211" => 60}
    return minimum_stock_list
  end
end
