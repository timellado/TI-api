# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

product_list = [[1001, 'Arroz grano corto', 0, 720.0, 1.0, 10, 240], [1002, 'Vinagre de arroz', 0, 720.0, 1.0, 10, 300], [1003, 'Azúcar', 0, 720.0, 0.1, 100, 320], [1004, 'Sal', 0, 720.0, 0.1, 100, 400], [1005, 'Kanikama entero', 0, 24.0, 1.0, 5, 260], [1006, 'Camarón', 0, 720.0, 100.0, 1, 120], [1007, 'Filete de salmón', 0, 20.0, 1.0, 8, 300], [1008, 'Filete de salmón ahumado', 0, 48.0, 0.5, 10, 220], [1009, 'Filete de atún', 0, 15.0, 1.0, 3, 400], [1010, 'Palta', 0, 30.0, 3.0, 5, 480], [1011, 'Sésamo', 0, 168.0, 0.55, 4, 120], [1012, 'Queso crema', 0, 72.0, 1.0, 7, 150], [1013, 'Masago', 0, 12.0, 0.01, 10, 320], [1014, 'Cebollín entero', 0, 24.0, 1.0, 5, 240], [1015, 'Ciboulette entero', 0, 30.0, 0.1, 4, 400], [1016, 'Nori entero', 0, 240.0, 1.0, 8, 600], [1101, 'Arroz cocido', 0, 3.0, 1.0, 10, 40], [1105, 'Kanikama para roll', 0, 3.0, 1.0, 10, 10], [1106, 'Camarón cocido', 0, 4.0, 1.0, 100, 30], [1107, 'Salmón cortado para roll', 0, 2.0, 1.0, 11, 20], [1108, 'Salmón ahumado cortado para roll', 0, 4.0, 1.0, 6, 20], [1109, 'Atún cortado para roll', 0, 1.5, 1.0, 12, 30], [1110, 'Palta cortada para envoltura', 0, 2.0, 1.0, 6, 10], [1111, 'Sésamo tostado', 0, 12.0, 0.5, 2, 30], [1112, 'Queso crema para roll', 0, 24.0, 1.0, 20, 10], [1114, 'Cebollín cortado para roll', 0, 2.0, 1.0, 4, 10], [1115, 'Ciboulette picado para roll', 0, 3.0, 1.0, 8, 10], [1116, 'Nori entero cortado para roll', 0, 24.0, 1.0, 10, 40], [1201, 'Arroz cocido para roll', 0, 2.0, 1.0, 10, 10], [1207, 'Salmón cortado para nigiri', 0, 2.0, 1.0, 12, 20], [1209, 'Atún cortado para nigiri', 0, 1.5, 1.0, 14, 30], [1210, 'Palta cortada para roll', 0, 2.3, 1.0, 9, 10], [1211, 'Sésamo tostado para envoltura', 0, 12.0, 1.0, 10, 10], [1215, 'Ciboulette picado para envoltura', 0, 3.0, 1.0, 8, 10], [1216, 'Nori entero cortado para nigiri', 0, 24.0, 1.0, 10, 30], [1301, 'Arroz cocido para nigiri', 0, 2.0, 1.0, 5, 10], [1307, 'Salmón cortado para sashimi', 0, 1.2, 1.0, 11, 30], [1309, 'Atún cortado para sashimi', 0, 1.2, 1.0, 11, 50], [1310, 'Palta cortada para nigiri', 0, 2.0, 1.0, 12, 10], [1407, 'Salmón cortado para envoltura', 0, 2.0, 1.0, 14, 30], [10001, 'California Maki Sésamo', 4500, 1.0, 1.0, 1, 10], [10002, 'California Maki Masago', 4500, 1.0, 1.0, 1, 20], [10003, 'California Maki Mix', 4700, 1.0, 1.0, 1, 30], [10004, 'California Ebi Sésamo', 4700, 1.0, 1.0, 1, 10], [10005, 'California Ebi Masago', 4700, 1.0, 1.0, 1, 20], [10006, 'California Sake Sésamo', 4900, 1.0, 1.0, 1, 10], [10007, 'California Sake Masago', 4900, 1.0, 1.0, 1, 20], [10008, 'California Maguro Sésamo', 4900, 1.0, 1.0, 1, 20], [10009, 'California Maguro Masago', 4900, 1.0, 1.0, 1, 30], [10010, 'Ebi', 4900, 1.0, 1.0, 1, 10], [10011, 'Ebi Especial', 5700, 1.0, 1.0, 1, 20], [10012, 'Turo', 5700, 1.0, 1.0, 1, 20], [10013, 'Coca', 5700, 1.0, 1.0, 1, 10], [10014, 'Akita', 4900, 1.0, 1.0, 1, 10], [10015, 'Delicia', 5700, 1.0, 1.0, 1, 20], [10016, 'Beto', 5700, 1.0, 1.0, 1, 20], [10017, 'Avocado', 5700, 1.0, 1.0, 1, 10], [10018, 'Maki Salmón', 5700, 1.0, 1.0, 1, 10], [10019, 'Ebi Salmón', 5700, 1.0, 1.0, 1, 10], [10020, 'Ebi Salmón Especial', 5900, 1.0, 1.0, 1, 20], [10021, 'Maguro Salmón', 5900, 1.0, 1.0, 1, 10], [10022, 'Sake Ciboulette', 5500, 1.0, 1.0, 1, 20], [10023, 'Maguro Ciboulette', 5500, 1.0, 1.0, 1, 20], [10024, 'Vegan Sésamo', 4900, 1.0, 1.0, 1, 20], [10025, 'Vegan Masago', 4900, 1.0, 1.0, 1, 20], [20001, 'Nigiri Avocado', 2700, 1.0, 1.0, 1, 10], [20002, 'Nigiri Ebi', 2700, 1.0, 1.0, 1, 10], [20003, 'Nigiri Sake', 2700, 1.0, 1.0, 1, 10], [20004, 'Nigiri Maguro', 2700, 1.0, 1.0, 1, 10], [20005, 'Nigiri Maguro Especial', 2700, 1.0, 1.0, 1, 20], [30001, 'Sashimi Salmón 9 cortes', 7900, 1.0, 1.0, 1, 10], [30002, 'Sashimi Salmón 12 cortes', 9900, 1.0, 1.0, 1, 10], [30003, 'Sashimi Salmón 15 cortes', 12500, 1.0, 1.0, 1, 10], [30004, 'Sashimi Atún 9 cortes', 7900, 1.0, 1.0, 1, 10], [30005, 'Sashimi Atún 12 cortes', 9900, 1.0, 1.0, 1, 10], [30006, 'Sashimi Atún 15 cortes', 12500, 1.0, 1.0, 1, 10], [30007, 'Sashimi Mix 12 cortes', 9900, 1.0, 1.0, 1, 10], [30008, 'Sashimi Mix 18 cortes', 15990, 1.0, 1.0, 1, 10]]


product_list.each do |sku, nombre, precio_venta, vencimiento, espacio_ocupado_unidad, lote_produccion, tiempo_produccion|
  Product.create( sku: sku,
  nombre: nombre,
  precio_venta: precio_venta ,
  vencimiento: vencimiento,
  espacio_ocupado_unidad: espacio_ocupado_unidad,
  lote_produccion: lote_produccion,
  tiempo_produccion: tiempo_produccion)
end


ingredients_list = [[1001, 10.0, 8.0, 8.0], [1003, 10.0, 3.0, 30.0], [1004, 10.0, 1.6, 16.0], [1002, 10.0, 4.0, 4.0], [1005, 10.0, 1.0, 1.0], [1006, 100.0, 100.0, 1.0], [1007, 11.0, 0.99, 1.0], [1008, 6.0, 0.48, 1.0], [1009, 12.0, 0.96, 1.0], [1010, 6.0, 3.0, 1.0], [1011, 2.0, 1.1, 2.0], [1111, 10.0, 0.5, 1.0], [1012, 20.0, 1.0, 1.0], [1014, 4.0, 1.0, 1.0], [1015, 8.0, 0.2, 2.0], [1016, 10.0, 11.0, 11.0], [1101, 10.0, 1.0, 1.0], [1007, 12.0, 0.96, 1.0], [1009, 14.0, 0.98, 1.0], [1010, 9.0, 3.0, 1.0], [1015, 8.0, 0.4, 4.0], [1016, 10.0, 2.0, 2.0], [1101, 5.0, 1.0, 1.0], [1009, 11.0, 0.99, 1.0], [1010, 12.0, 3.0, 1.0], [1007, 14.0, 0.98, 1.0], [1201, 1.0, 1.0, 1.0], [1105, 1.0, 1.0, 1.0], [1210, 1.0, 1.0, 1.0], [1211, 1.0, 1.0, 1.0], [1116, 1.0, 1.0, 1.0], [1013, 1.0, 0.05, 5.0], [1106, 1.0, 4.0, 4.0], [1107, 1.0, 1.0, 1.0], [1109, 1.0, 1.0, 1.0], [1110, 1.0, 1.0, 1.0], [1114, 1.0, 1.0, 1.0], [1112, 1.0, 1.0, 1.0], [1108, 1.0, 1.0, 1.0], [1115, 1.0, 1.0, 1.0], [1407, 1.0, 1.0, 1.0], [1215, 1.0, 1.0, 1.0], [1301, 1.0, 1.0, 1.0], [1207, 1.0, 1.0, 1.0], [1310, 1.0, 1.0, 1.0], [1216, 1.0, 1.0, 1.0], [1209, 1.0, 1.0, 1.0], [1307, 1.0, 3.0, 3.0], [1307, 1.0, 4.0, 4.0], [1307, 1.0, 5.0, 5.0], [1309, 1.0, 3.0, 3.0], [1309, 1.0, 4.0, 4.0], [1309, 1.0, 5.0, 5.0], [1309, 1.0, 2.0, 2.0], [1307, 1.0, 2.0, 2.0]]

ingredients_list.each do |sku, lote_produccion,cantidad_para_lote, unidades_bodega|
  Ingredient.create(
  sku: sku,
  cantidad_para_lote: cantidad_para_lote,
  lote_produccion: lote_produccion,
  unidades_bodega: unidades_bodega)
end



Group.create(
  [
    {
      grupo: 1
    },
    {
      grupo: 2
    },
    {
      grupo: 3
    },
    {
      grupo: 4
    },
    {
      grupo: 5
    },
    {
      grupo: 6
    },
    {
      grupo: 7
    },
    {
      grupo: 8
    },
    {
      grupo: 9
    },
    {
      grupo: 10
    },
    {
      grupo: 11
    },
    {
      grupo: 12
    },
    {
      grupo: 13
    },
    {
      grupo: 14
    }
  ]
)



Product.find_by_sku("1001").groups << Group.where(grupo:[1,2,3,4,5,6,7,8,9,10,11,12,13,14])
Product.find_by_sku("1002").groups << Group.where(grupo:[6,8,14])
Product.find_by_sku("1003").groups << Group.where(grupo:[2,6,7])
Product.find_by_sku("1004").groups << Group.where(grupo:[3,4,10])
Product.find_by_sku("1005").groups << Group.where(grupo:[4,5,8])
Product.find_by_sku("1006").groups << Group.where(grupo:[2,5,7])
Product.find_by_sku("1007").groups << Group.where(grupo:[6,11,13])
Product.find_by_sku("1008").groups << Group.where(grupo:[1,5,7])
Product.find_by_sku("1009").groups << Group.where(grupo:[1,8,9])
Product.find_by_sku("1010").groups << Group.where(grupo:[3,9,13])
Product.find_by_sku("1011").groups << Group.where(grupo:[2,10,11])
Product.find_by_sku("1012").groups << Group.where(grupo:[11,12,13])
Product.find_by_sku("1013").groups << Group.where(grupo:[10,12,14])
Product.find_by_sku("1014").groups << Group.where(grupo:[3,4,9])
Product.find_by_sku("1015").groups << Group.where(grupo:[1,12,14])
Product.find_by_sku("1016").groups << Group.where(grupo:[1,2,3,4,5,6,7,8,9,10,11,12,13,14])



Product.find_by_sku('30004').ingredients << Ingredient.where(sku:[1309])
Product.find_by_sku('10001').ingredients << Ingredient.where(sku:[1201, 1105, 1210, 1211, 1116])
Product.find_by_sku('10002').ingredients << Ingredient.where(sku:[1201, 1105, 1013, 1210, 1116])
Product.find_by_sku('10003').ingredients << Ingredient.where(sku:[1201, 1105, 1013, 1210, 1211, 1116])
Product.find_by_sku('10004').ingredients << Ingredient.where(sku:[1201, 1106, 1210, 1211, 1116])
Product.find_by_sku('1301').ingredients << Ingredient.where(sku:[1101])
Product.find_by_sku('10006').ingredients << Ingredient.where(sku:[1201, 1210, 1107, 1211, 1116])
Product.find_by_sku('10007').ingredients << Ingredient.where(sku:[1201, 1013, 1210, 1107, 1116])
Product.find_by_sku('10008').ingredients << Ingredient.where(sku:[1201, 1109, 1210, 1211, 1116])
Product.find_by_sku('10009').ingredients << Ingredient.where(sku:[1201, 1109, 1013, 1210, 1116])
Product.find_by_sku('10010').ingredients << Ingredient.where(sku:[1201, 1106, 1210, 1110, 1116])
Product.find_by_sku('1307').ingredients << Ingredient.where(sku:[1007])
Product.find_by_sku('10012').ingredients << Ingredient.where(sku:[1201, 1106, 1110, 1112, 1108, 1116])
Product.find_by_sku('1309').ingredients << Ingredient.where(sku:[1009])
Product.find_by_sku('1310').ingredients << Ingredient.where(sku:[1010])
Product.find_by_sku('10015').ingredients << Ingredient.where(sku:[1201, 1109, 1115, 1110, 1112, 1116])
Product.find_by_sku('10016').ingredients << Ingredient.where(sku:[1201, 1106, 1110, 1112, 1107, 1116])
Product.find_by_sku('10017').ingredients << Ingredient.where(sku:[1201, 1110, 1112, 1107, 1116])
Product.find_by_sku('10018').ingredients << Ingredient.where(sku:[1201, 1105, 1112, 1407, 1116])
Product.find_by_sku('10019').ingredients << Ingredient.where(sku:[1201, 1106, 1210, 1116, 1407])
Product.find_by_sku('10020').ingredients << Ingredient.where(sku:[1201, 1116, 1106, 1112, 1114, 1407])
Product.find_by_sku('10021').ingredients << Ingredient.where(sku:[1201, 1116, 1109, 1114, 1407])
Product.find_by_sku('10022').ingredients << Ingredient.where(sku:[1201, 1116, 1107, 1112, 1210, 1215])
Product.find_by_sku('10023').ingredients << Ingredient.where(sku:[1201, 1116, 1109, 1112, 1210, 1215])
Product.find_by_sku('10024').ingredients << Ingredient.where(sku:[1201, 1116, 1210, 1114, 1115, 1211])
Product.find_by_sku('10025').ingredients << Ingredient.where(sku:[1201, 1116, 1210, 1114, 1115, 1013])
Product.find_by_sku('10013').ingredients << Ingredient.where(sku:[1201, 1106, 1110, 1112, 1116])
Product.find_by_sku('1201').ingredients << Ingredient.where(sku:[1101])
Product.find_by_sku('30002').ingredients << Ingredient.where(sku:[1307])
Product.find_by_sku('30003').ingredients << Ingredient.where(sku:[1307])
Product.find_by_sku('10005').ingredients << Ingredient.where(sku:[1201, 1106, 1013, 1210, 1116])
Product.find_by_sku('10014').ingredients << Ingredient.where(sku:[1201, 1105, 1110, 1112, 1116])
Product.find_by_sku('30006').ingredients << Ingredient.where(sku:[1309])
Product.find_by_sku('1207').ingredients << Ingredient.where(sku:[1007])
Product.find_by_sku('30008').ingredients << Ingredient.where(sku:[1309, 1307])
Product.find_by_sku('1209').ingredients << Ingredient.where(sku:[1009])
Product.find_by_sku('1210').ingredients << Ingredient.where(sku:[1010])
Product.find_by_sku('1211').ingredients << Ingredient.where(sku:[1111])
Product.find_by_sku('1215').ingredients << Ingredient.where(sku:[1015])
Product.find_by_sku('1216').ingredients << Ingredient.where(sku:[1016])
Product.find_by_sku('20001').ingredients << Ingredient.where(sku:[1301, 1207, 1310, 1112, 1216])
Product.find_by_sku('30007').ingredients << Ingredient.where(sku:[1309, 1307])
Product.find_by_sku('1101').ingredients << Ingredient.where(sku:[1001, 1003, 1004, 1002])
Product.find_by_sku('1105').ingredients << Ingredient.where(sku:[1005])
Product.find_by_sku('1106').ingredients << Ingredient.where(sku:[1006])
Product.find_by_sku('1107').ingredients << Ingredient.where(sku:[1007])
Product.find_by_sku('1108').ingredients << Ingredient.where(sku:[1008])
Product.find_by_sku('1109').ingredients << Ingredient.where(sku:[1009])
Product.find_by_sku('1110').ingredients << Ingredient.where(sku:[1010])
Product.find_by_sku('1111').ingredients << Ingredient.where(sku:[1011])
Product.find_by_sku('1112').ingredients << Ingredient.where(sku:[1012])
Product.find_by_sku('20004').ingredients << Ingredient.where(sku:[1301, 1216, 1209])
Product.find_by_sku('1114').ingredients << Ingredient.where(sku:[1014])
Product.find_by_sku('1115').ingredients << Ingredient.where(sku:[1015])
Product.find_by_sku('1116').ingredients << Ingredient.where(sku:[1016])
Product.find_by_sku('20005').ingredients << Ingredient.where(sku:[1301, 1216, 1209, 1310, 1112])
Product.find_by_sku('30005').ingredients << Ingredient.where(sku:[1309])
Product.find_by_sku('10011').ingredients << Ingredient.where(sku:[1201, 1106, 1114, 1110, 1112, 1116])
Product.find_by_sku('20003').ingredients << Ingredient.where(sku:[1301, 1216, 1207])
Product.find_by_sku('30001').ingredients << Ingredient.where(sku:[1307])
Product.find_by_sku('20002').ingredients << Ingredient.where(sku:[1301, 1216, 1106])
Product.find_by_sku('1407').ingredients << Ingredient.where(sku:[1007])
