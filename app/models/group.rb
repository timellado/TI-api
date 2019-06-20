require 'logica'
require 'bodega'
require 'variable'
class Group < ApplicationRecord
    include Logica
    include Bodega
    include Variable

    has_and_belongs_to_many :products, dependent: :destroy

    def self.mover_productos_a_despacho_y_despachar(sku,cantidad,almacen_destino, oc)
        lista_id_sku_recepcion = self.listar_no_vencidos(Variable.v_recepcion,sku)
        lista_id_sku_i1 = self.listar_no_vencidos(Variable.v_inventario1,sku)
        lista_id_sku_i2 = self.listar_no_vencidos(Variable.v_inventario2,sku)
        lista_id_sku_pulmon = self.listar_no_vencidos(Variable.v_pulmon,sku)
  
          cont = 0
  
          (0..lista_id_sku_recepcion.length-1).each do |i|
              if cont >= cantidad
                break
              end
              p "moviendo SKU: "+sku.to_s+" desde recepcion, ID: "+lista_id_sku_recepcion[i][0].to_s
              Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_recepcion[i][0])
              Bodega.Mover_bodega(almacen_destino,lista_id_sku_recepcion[i][0], oc)
              p "se movio" 
              cont = cont + 1
  
          end
  
          (0..lista_id_sku_i1.length-1).each do |i|
            if cont >= cantidad
              break
            end
            p "moviendo SKU: "+sku.to_s+" desde Inv 1, ID: "+lista_id_sku_i1[i][0].to_s
              Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i1[i][0])
              Bodega.Mover_bodega(almacen_destino,lista_id_sku_i1[i][0], oc)
            p "se movio"
              cont = cont + 1
  
          end
  
          (0..lista_id_sku_i2.length-1).each do |i|
            if cont >= cantidad
              break
            end
            p "moviendo SKU: "+sku.to_s+" desde Inv 1, ID: "+lista_id_sku_i2[i][0].to_s
              Bodega.Mover_almacen(Variable.v_despacho,lista_id_sku_i2[i][0])
              Bodega.Mover_bodega(almacen_destino,lista_id_sku_i2[i][0], oc)
              p "se movio"
              cont = cont + 1
  
          end
  
          espacio_libre_rec = self.contar_espacio_libre(Variable.v_recepcion)
  
     
            (0..lista_id_sku_pulmon.length-1).each do |i|
              if cont >= cantidad
                break
              end
              product_id = lista_id_sku_pulmon[i][0]
              p "moviendo SKU: "+sku.to_s+" desde pulmón, ID: "+product_id.to_s
              Bodega.Mover_almacen(Variable.v_despacho,product_id)
              Bodega.Mover_bodega(almacen_destino,product_id, oc)
              p "se movio"
              cont = cont +1
  
            end
      end

end
