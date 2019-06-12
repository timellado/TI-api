module StockMinimo
def self.get_minimum_stock
  minimum_stock_list = [
    [10017, 20],
    [30007, 20],
    [10018, 20],
    [10001, 20],
    [10002, 20],
    [10003, 20],
    [10004, 20],
    [10005, 20],
    [10006, 20],
    [10007, 20],
    [10008, 20],
    [10009, 20],
    [10010, 20],
    [10011, 20],
    [10012, 20],
    [10013, 20],
    [10014, 20],
    [10015, 20],
    [10016, 20],
    [20001, 20],
    [20002, 20],
    [20003, 20],
    [10019, 20],
    [10021, 20],
    [10022, 20],
    [10023, 20],
    [10024, 20],
    [10025, 20],
    [20005, 20],
    [20004, 20],
    [30001, 20],
    [30002, 20],
    [30003, 20],
    [30004, 20],
    [30005, 20],
    [30006, 20],
    [10020, 20],
    [30008, 20]
  ]
  return minimum_stock_list
end

def self.get_minimum_stock_dic
  minimum_stock_list = {
    '10017' => 20,
    '30007' => 20,
    '10018' => 20,
    '10001' => 20,
    '10002' => 20,
    '10003' => 20,
    '10004' => 20,
    '10005' => 20,
    '10006' => 20,
    '10007' => 20,
    '10008' => 20,
    '10009' => 20,
    '10010' => 20,
    '10011' => 20,
    '10012' => 20,
    '10013' => 20,
    '10014' => 20,
    '10015' => 20,
    '10016' => 20,
    '20001' => 20,
    '20002' => 20,
    '20003' => 20,
    '10019' => 20,
    '10021' => 20,
    '10022' => 20,
    '10023' => 20,
    '10024' => 20,
    '10025' => 20,
    '20005' => 20,
    '20004' => 20,
    '30001' => 20,
    '30002' => 20,
    '30003' => 20,
    '30004' => 20,
    '30005' => 20,
    '30006' => 20,
    '10020' => 20,
    '30008' => 20
  }
  return minimum_stock_list
end

def self.get_minimum_stock_dic2
  minimum_stock_list = {
    "1301" => 50,
    "1201" => 250,
    "1209" => 20,
    "1109" => 50,
    "1309" => 170,
    "1106" => 400,
    "1114" => 50,
    "1215" => 20,
    "1115" => 30,
    "1105" => 50,
    "1013" => 300,
    "1216" => 50,
    "1116" => 250,
    "1110" => 80,
    "1310" => 20,
    "1210" => 150,
    "1112" => 130,
    "1108" => 10,
    "1407" => 40,
    "1207" => 20,
    "1107" => 50,
    "1307" => 170,
    "1211" => 60,
    '10017' => 20,
    '30007' => 20,
    '10018' => 20,
    '10001' => 20,
    '10002' => 20,
    '10003' => 20,
    '10004' => 20,
    '10005' => 20,
    '10006' => 20,
    '10007' => 20,
    '10008' => 20,
    '10009' => 20,
    '10010' => 20,
    '10011' => 20,
    '10012' => 20,
    '10013' => 20,
    '10014' => 20,
    '10015' => 20,
    '10016' => 20,
    '20001' => 20,
    '20002' => 20,
    '20003' => 20,
    '10019' => 20,
    '10021' => 20,
    '10022' => 20,
    '10023' => 20,
    '10024' => 20,
    '10025' => 20,
    '20005' => 20,
    '20004' => 20,
    '30001' => 20,
    '30002' => 20,
    '30003' => 20,
    '30004' => 20,
    '30005' => 20,
    '30006' => 20,
    '10020' => 20,
    '30008' => 20
  }
  return minimum_stock_list
end

def self.get_product_ingredient
  product_ingredient = {
    '1101'=> [
      ['1001', '8'],
      ['1003', '3'],
      ['1004', '2'],
      ['1002', '4']
    ],
    '1105'=> [
      ['1005', '1']
    ],
    '1106'=> [
      ['1006', '1']
    ],
    '1107'=> [
      ['1007', '1']
    ],
    '1108'=> [
      ['1008', '1']
    ],
    '1109'=> [
      ['1009', '1']
    ],
    '1110'=> [
      ['1010', '1']
    ],
    '1111'=> [
      ['1011', '2']
    ],
    '1211'=> [
      ['1111', '1']
    ],
    '1112'=> [
      ['1012', '1']
    ],
    '1114'=> [
      ['1014', '1']
    ],
    '1115'=> [
      ['1015', '2']
    ],
    '1116'=> [
      ['1016', '11']
    ],
    '1201'=> [
      ['1101', '1']
    ],
    '1207'=> [
      ['1007', '1']
    ],
    '1209'=> [
      ['1009', '1']
    ],
    '1210'=> [
      ['1010', '1']
    ],
    '1215'=> [
      ['1015', '4']
    ],
    '1216'=> [
      ['1016', '2']
    ],
    '1301'=> [
      ['1101', '1']
    ],
    '1307'=> [
      ['1007', '1']
    ],
    '1309'=> [
      ['1009', '1']
    ],
    '1310'=> [
      ['1010', '1']
    ],
    '1407'=> [
      ['1007', '1']
    ],
    '10001'=> [
      ['1201', '1'],
      ['1105', '1'],
      ['1210', '1'],
      ['1211', '1'],
      ['1116', '1']
    ],
    '10002'=> [
      ['1201', '1'],
      ['1105', '1'],
      ['1013', '5'],
      ['1210', '1'],
      ['1116', '1']
    ],
    '10003'=> [
      ['1201', '1'],
      ['1105', '1'],
      ['1013', '5'],
      ['1210', '1'],
      ['1211', '1'],
      ['1116', '1']
    ],
    '10004'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1210', '1'],
      ['1211', '1'],
      ['1116', '1']
    ],
    '10005'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1013', '5'],
      ['1210', '1'],
      ['1116', '1']
    ],
    '10006'=> [
      ['1201', '1'],
      ['1210', '1'],
      ['1107', '1'],
      ['1211', '1'],
      ['1116', '1']
    ],
    '10007'=> [
      ['1201', '1'],
      ['1013', '5'],
      ['1210', '1'],
      ['1107', '1'],
      ['1116', '1']
    ],
    '10008'=> [
      ['1201', '1'],
      ['1109', '1'],
      ['1210', '1'],
      ['1211', '1'],
      ['1116', '1']
    ],
    '10009'=> [
      ['1201', '1'],
      ['1109', '1'],
      ['1013', '5'],
      ['1210', '1'],
      ['1116', '1']
    ],
    '10010'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1210', '1'],
      ['1110', '1'],
      ['1116', '1']
    ],
    '10011'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1114', '1'],
      ['1110', '1'],
      ['1112', '1'],
      ['1116', '1']
    ],
    '10012'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1110', '1'],
      ['1112', '1'],
      ['1108', '1'],
      ['1116', '1']
    ],
    '10013'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1110', '1'],
      ['1112', '1'],
      ['1116', '1']
    ],
    '10014'=> [
      ['1201', '1'],
      ['1105', '1'],
      ['1110', '1'],
      ['1112', '1'],
      ['1116', '1']
    ],
    '10015'=> [
      ['1201', '1'],
      ['1109', '1'],
      ['1115', '1'],
      ['1110', '1'],
      ['1112', '1'],
      ['1116', '1']
    ],
    '10016'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1110', '1'],
      ['1112', '1'],
      ['1107', '1'],
      ['1116', '1']
    ],
    '10017'=> [
      ['1201', '1'],
      ['1110', '1'],
      ['1112', '1'],
      ['1107', '1'],
      ['1116', '1']
    ],
    '10018'=> [
      ['1201', '1'],
      ['1105', '1'],
      ['1112', '1'],
      ['1407', '1'],
      ['1116', '1']
    ],
    '10019'=> [
      ['1201', '1'],
      ['1106', '4'],
      ['1210', '1'],
      ['1116', '1'],
      ['1407', '1']
    ],
    '10020'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1106', '4'],
      ['1112', '1'],
      ['1114', '1'],
      ['1407', '1']
    ],
    '10021'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1109', '1'],
      ['1114', '1'],
      ['1407', '1']
    ],
    '10022'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1107', '1'],
      ['1112', '1'],
      ['1210', '1'],
      ['1215', '1']
    ],
    '10023'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1109', '1'],
      ['1112', '1'],
      ['1210', '1'],
      ['1215', '1']
    ],
    '10024'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1210', '1'],
      ['1114', '1'],
      ['1115', '1'],
      ['1211', '1']
    ],
    '10025'=> [
      ['1201', '1'],
      ['1116', '1'],
      ['1210', '1'],
      ['1114', '1'],
      ['1115', '1'],
      ['1013', '5']
    ],
    '20001'=> [
      ['1301', '1'],
      ['1207', '1'],
      ['1310', '1'],
      ['1112', '1'],
      ['1216', '1']
    ],
    '20002'=> [
      ['1301', '1'],
      ['1216', '1'],
      ['1106', '4']
    ],
    '20003'=> [
      ['1301', '1'],
      ['1216', '1'],
      ['1207', '1']
    ],
    '20004'=> [
      ['1301', '1'],
      ['1216', '1'],
      ['1209', '1']
    ],
    '20005'=> [
      ['1301', '1'],
      ['1216', '1'],
      ['1209', '1'],
      ['1310', '1'],
      ['1112', '1']
    ],
    '30001'=> [
      ['1307', '3']
    ],
    '30002'=> [
      ['1307', '4']
    ],
    '30003'=> [
      ['1307', '5']
    ],
    '30004'=> [
      ['1309', '3']
    ],
    '30005'=> [
      ['1309', '4']
    ],
    '30006'=> [
      ['1309', '5']
    ],
    '30007'=> [
      ['1309', '2'],
      ['1307', '2']
    ],
    '30008'=> [
      ['1309', '3'],
      ['1307', '3']
    ]
  }
  return product_ingredient
end

def self.get_product_ingredient_dic
  product_ingredient = {
    '1101'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1001'=> 8,
      '1003'=> 3,
      '1004'=> 2,
      '1002'=> 4
    },
    '1105'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1005'=> 1
    },
    '1106'=> {
      'tipo'=> 'fabrica',
      'lote'=> 100,
      '1006'=> 1
    },
    '1107'=> {
      'tipo'=> 'fabrica',
      'lote'=> 11,
      '1007'=> 1
    },
    '1108'=> {
      'tipo'=> 'fabrica',
      'lote'=> 6,
      '1008'=> 1
    },
    '1109'=> {
      'tipo'=> 'fabrica',
      'lote'=> 12,
      '1009'=> 1
    },
    '1110'=> {
      'tipo'=> 'fabrica',
      'lote'=> 6,
      '1010'=> 1
    },
    '1111'=> {
      'tipo'=> 'fabrica',
      'lote'=> 2,
      '1011'=> 2
    },
    '1211'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1111'=> 1
    },
    '1112'=> {
      'tipo'=> 'fabrica',
      'lote'=> 20,
      '1012'=> 1
    },
    '1114'=> {
      'tipo'=> 'fabrica',
      'lote'=> 4,
      '1014'=> 1
    },
    '1115'=> {
      'tipo'=> 'fabrica',
      'lote'=> 8,
      '1015'=> 2
    },
    '1116'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1016'=> 11
    },
    '1201'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1101'=> 1
    },
    '1207'=> {
      'tipo'=> 'fabrica',
      'lote'=> 12,
      '1007'=> 1
    },
    '1209'=> {
      'tipo'=> 'fabrica',
      'lote'=> 14,
      '1009'=> 1
    },
    '1210'=> {
      'tipo'=> 'fabrica',
      'lote'=> 9,
      '1010'=> 1
    },
    '1215'=> {
      'tipo'=> 'fabrica',
      'lote'=> 8,
      '1015'=> 4
    },
    '1216'=> {
      'tipo'=> 'fabrica',
      'lote'=> 10,
      '1016'=> 2
    },
    '1301'=> {
      'tipo'=> 'fabrica',
      'lote'=> 5,
      '1101'=> 1
    },
    '1307'=> {
      'tipo'=> 'fabrica',
      'lote'=> 11,
      '1007'=> 1
    },
    '1309'=> {
      'tipo'=> 'fabrica',
      'lote'=> 11,
      '1009'=> 1
    },
    '1310'=> {
      'tipo'=> 'fabrica',
      'lote'=> 12,
      '1010'=> 1
    },
    '1407'=> {
      'tipo'=> 'fabrica',
      'lote'=> 14,
      '1007'=> 1
    },
    '10001'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1105'=> 1,
      '1210'=> 1,
      '1211'=> 1,
      '1116'=> 1
    },
    '10002'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1105'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1116'=> 1
    },
    '10003'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1105'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1211'=> 1,
      '1116'=> 1
    },
    '10004'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1210'=> 1,
      '1211'=> 1,
      '1116'=> 1
    },
    '10005'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1013'=> 5,
      '1210'=> 1,
      '1116'=> 1
    },
    '10006'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1210'=> 1,
      '1107'=> 1,
      '1211'=> 1,
      '1116'=> 1
    },
    '10007'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1107'=> 1,
      '1116'=> 1
    },
    '10008'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1109'=> 1,
      '1210'=> 1,
      '1211'=> 1,
      '1116'=> 1
    },
    '10009'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1109'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1116'=> 1
    },
    '10010'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1210'=> 1,
      '1110'=> 1,
      '1116'=> 1
    },
    '10011'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1114'=> 1,
      '1110'=> 1,
      '1112'=> 1,
      '1116'=> 1
    },
    '10012'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1110'=> 1,
      '1112'=> 1,
      '1108'=> 1,
      '1116'=> 1
    },
    '10013'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1110'=> 1,
      '1112'=> 1,
      '1116'=> 1
    },
    '10014'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1105'=> 1,
      '1110'=> 1,
      '1112'=> 1,
      '1116'=> 1
    },
    '10015'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1109'=> 1,
      '1115'=> 1,
      '1110'=> 1,
      '1112'=> 1,
      '1116'=> 1
    },
    '10016'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1110'=> 1,
      '1112'=> 1,
      '1107'=> 1,
      '1116'=> 1
    },
    '10017'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1110'=> 1,
      '1112'=> 1,
      '1107'=> 1,
      '1116'=> 1
    },
    '10018'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1105'=> 1,
      '1112'=> 1,
      '1407'=> 1,
      '1116'=> 1
    },
    '10019'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1106'=> 4,
      '1210'=> 1,
      '1116'=> 1,
      '1407'=> 1
    },
    '10020'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1106'=> 4,
      '1112'=> 1,
      '1114'=> 1,
      '1407'=> 1
    },
    '10021'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1109'=> 1,
      '1114'=> 1,
      '1407'=> 1
    },
    '10022'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1107'=> 1,
      '1112'=> 1,
      '1210'=> 1,
      '1215'=> 1
    },
    '10023'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1109'=> 1,
      '1112'=> 1,
      '1210'=> 1,
      '1215'=> 1
    },
    '10024'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1210'=> 1,
      '1114'=> 1,
      '1115'=> 1,
      '1211'=> 1
    },
    '10025'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1201'=> 1,
      '1116'=> 1,
      '1210'=> 1,
      '1114'=> 1,
      '1115'=> 1,
      '1013'=> 5
    },
    '20001'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1301'=> 1,
      '1207'=> 1,
      '1310'=> 1,
      '1112'=> 1,
      '1216'=> 1
    },
    '20002'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1301'=> 1,
      '1216'=> 1,
      '1106'=> 4
    },
    '20003'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1301'=> 1,
      '1216'=> 1,
      '1207'=> 1
    },
    '20004'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1301'=> 1,
      '1216'=> 1,
      '1209'=> 1
    },
    '20005'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1301'=> 1,
      '1216'=> 1,
      '1209'=> 1,
      '1310'=> 1,
      '1112'=> 1
    },
    '30001'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1307'=> 3
    },
    '30002'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1307'=> 4
    },
    '30003'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1307'=> 5
    },
    '30004'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1309'=> 3
    },
    '30005'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1309'=> 4
    },
    '30006'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1309'=> 5
    },
    '30007'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1309'=> 2,
      '1307'=> 2
    },
    '30008'=> {
      'tipo'=> 'cocina',
      'lote'=> 1,
      '1309'=> 3,
      '1307'=> 3
    }
  }
  return product_ingredient
end

def self.get_product_all_ingredient_dic
  product_ingredient = {
    '1101'=> {
      'lote'=> 10,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1
    },
    '1105'=> {
      'lote'=> 10,
      '1005'=> 1
    },
    '1106'=> {
      'lote'=> 100,
      '1006'=> 1
    },
    '1107'=> {
      'lote'=> 11,
      '1007'=> 1
    },
    '1108'=> {
      'lote'=> 6,
      '1008'=> 1
    },
    '1109'=> {
      'lote'=> 12,
      '1009'=> 1
    },
    '1110'=> {
      'lote'=> 6,
      '1010'=> 1
    },
    '1111'=> {
      'lote'=> 2,
      '1011'=> 1
    },
    '1211'=> {
      'lote'=> 10,
      '1111'=> 1,
      '1011'=> 1
    },
    '1112'=> {
      'lote'=> 20,
      '1012'=> 1
    },
    '1114'=> {
      'lote'=> 4,
      '1014'=> 1
    },
    '1115'=> {
      'lote'=> 8,
      '1015'=> 1
    },
    '1116'=> {
      'lote'=> 10,
      '1016'=> 2
    },
    '1201'=> {
      'lote'=> 10,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1
    },
    '1207'=> {
      'lote'=> 12,
      '1007'=> 1
    },
    '1209'=> {
      'lote'=> 14,
      '1009'=> 1
    },
    '1210'=> {
      'lote'=> 9,
      '1010'=> 1
    },
    '1215'=> {
      'lote'=> 8,
      '1015'=> 1
    },
    '1216'=> {
      'lote'=> 10,
      '1016'=> 1
    },
    '1301'=> {
      'lote'=> 5,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1
    },
    '1307'=> {
      'lote'=> 11,
      '1007'=> 1
    },
    '1309'=> {
      'lote'=> 11,
      '1009'=> 1
    },
    '1310'=> {
      'lote'=> 12,
      '1010'=> 1
    },
    '1407'=> {
      'lote'=> 14,
      '1007'=> 1
    },
    '10001'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1105'=> 1,
      '1005'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10002'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1105'=> 1,
      '1005'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1010'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10003'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1105'=> 1,
      '1005'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1010'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10004'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10005'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1010'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10006'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1107'=> 1,
      '1007'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10007'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1010'=> 1,
      '1107'=> 1,
      '1007'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10008'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1109'=> 1,
      '1009'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10009'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1109'=> 1,
      '1009'=> 1,
      '1013'=> 5,
      '1210'=> 1,
      '1010'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10010'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1110'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10011'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1114'=> 1,
      '1014'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10012'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1108'=> 1,
      '1008'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10013'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10014'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1105'=> 1,
      '1005'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10015'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1109'=> 1,
      '1009'=> 1,
      '1115'=> 1,
      '1015'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10016'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1107'=> 1,
      '1007'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10017'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1110'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1107'=> 1,
      '1007'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10018'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1105'=> 1,
      '1005'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1407'=> 1,
      '1007'=> 1,
      '1116'=> 1,
      '1016'=> 2
    },
    '10019'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1106'=> 4,
      '1006'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1407'=> 1,
      '1007'=> 1
    },
    '10020'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1106'=> 4,
      '1006'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1114'=> 1,
      '1014'=> 1,
      '1407'=> 1,
      '1007'=> 1
    },
    '10021'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1109'=> 1,
      '1009'=> 1,
      '1114'=> 1,
      '1014'=> 1,
      '1407'=> 1,
      '1007'=> 1
    },
    '10022'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1107'=> 1,
      '1007'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1215'=> 1,
      '1015'=> 1
    },
    '10023'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1109'=> 1,
      '1009'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1210'=> 1,
      '1010'=> 1,
      '1215'=> 1,
      '1015'=> 1
    },
    '10024'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1210'=> 1,
      '1010'=> 1,
      '1114'=> 1,
      '1014'=> 1,
      '1115'=> 1,
      '1015'=> 1,
      '1211'=> 1,
      '1111'=> 1,
      '1011'=> 1
    },
    '10025'=> {
      'lote'=> 1,
      '1201'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1116'=> 1,
      '1016'=> 2,
      '1210'=> 1,
      '1010'=> 1,
      '1114'=> 1,
      '1014'=> 1,
      '1115'=> 1,
      '1015'=> 1,
      '1013'=> 5
    },
    '20001'=> {
      'lote'=> 1,
      '1301'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1207'=> 1,
      '1007'=> 1,
      '1310'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1,
      '1216'=> 1,
      '1016'=> 1
    },
    '20002'=> {
      'lote'=> 1,
      '1301'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1216'=> 1,
      '1016'=> 1,
      '1106'=> 4,
      '1006'=> 1
    },
    '20003'=> {
      'lote'=> 1,
      '1301'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1216'=> 1,
      '1016'=> 1,
      '1207'=> 1,
      '1007'=> 1
    },
    '20004'=> {
      'lote'=> 1,
      '1301'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1216'=> 1,
      '1016'=> 1,
      '1209'=> 1,
      '1009'=> 1
    },
    '20005'=> {
      'lote'=> 1,
      '1301'=> 1,
      '1101'=> 1,
      '1001'=> 1,
      '1003'=> 1,
      '1004'=> 1,
      '1002'=> 1,
      '1216'=> 1,
      '1016'=> 1,
      '1209'=> 1,
      '1009'=> 1,
      '1310'=> 1,
      '1010'=> 1,
      '1112'=> 1,
      '1012'=> 1
    },
    '30001'=> {
      'lote'=> 1,
      '1307'=> 3,
      '1007'=> 1
    },
    '30002'=> {
      'lote'=> 1,
      '1307'=> 4,
      '1007'=> 1
    },
    '30003'=> {
      'lote'=> 1,
      '1307'=> 5,
      '1007'=> 1
    },
    '30004'=> {
      'lote'=> 1,
      '1309'=> 3,
      '1009'=> 1
    },
    '30005'=> {
      'lote'=> 1,
      '1309'=> 4,
      '1009'=> 1
    },
    '30006'=> {
      'lote'=> 1,
      '1309'=> 5,
      '1009'=> 1
    },
    '30007'=> {
      'lote'=> 1,
      '1309'=> 2,
      '1009'=> 1,
      '1307'=> 2,
      '1007'=> 1
    },
    '30008'=> {
      'lote'=> 1,
      '1309'=> 3,
      '1009'=> 1,
      '1307'=> 3,
      '1007'=> 1
    }
  }
  return product_ingredient
end

def self.get_mi_materia_prima
  materia = {
    "1001"=>10, 
    "1004"=>100, 
    "1007"=>8, 
    "1008"=>10, 
    "1010"=>5, 
    "1011"=>7, 
    "1013"=>10, 
    "1016"=>8
  }
  return materia
end

def self.get_all_materia_prima
 materia = {
  '1001'=>  10,
  '1002'=>  10,
  '1003'=>  100,
  '1004'=>  100,
  '1005'=>  5,
  '1006'=>  1,
  '1007'=>  8,
  '1008'=>  10,
  '1009'=>  3,
  '1010'=>  5,
  '1011'=>  4,
  '1012'=>  7,
  '1013'=>  10,
  '1014'=>  5,
  '1015'=>  4,
  '1016'=>  8 
  }
    return materia
  end

end