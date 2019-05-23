# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190520003602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.integer "grupo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_products", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "product_id"
    t.index ["group_id"], name: "index_groups_products_on_group_id"
    t.index ["product_id"], name: "index_groups_products_on_product_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "sku"
    t.integer "lote_produccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "unidades_bodega"
    t.float "cantidad_para_lote"
    t.string "sku_product"
  end

  create_table "ingredients_products", force: :cascade do |t|
    t.bigint "ingredient_id"
    t.bigint "product_id"
    t.index ["ingredient_id"], name: "index_ingredients_products_on_ingredient_id"
    t.index ["product_id"], name: "index_ingredients_products_on_product_id"
  end

  create_table "ordencompras", force: :cascade do |t|
    t.string "sku"
    t.string "cliente"
    t.string "oc_id"
    t.string "fechaEntrega"
    t.integer "cantidad"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "sku"
    t.integer "cantidad"
    t.string "almacenId"
    t.boolean "aceptado"
    t.boolean "despachado"
    t.integer "precio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.string "nombre"
    t.integer "precio_venta"
    t.integer "vencimiento"
    t.float "espacio_ocupado_unidad"
    t.integer "lote_produccion"
    t.integer "tiempo_produccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products_ingredients", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "ingredient_id"
    t.index ["ingredient_id"], name: "index_products_ingredients_on_ingredient_id"
    t.index ["product_id"], name: "index_products_ingredients_on_product_id"
  end

  add_foreign_key "groups_products", "groups"
  add_foreign_key "groups_products", "products"
  add_foreign_key "ingredients_products", "ingredients"
  add_foreign_key "ingredients_products", "products"
  add_foreign_key "products_ingredients", "ingredients"
  add_foreign_key "products_ingredients", "products"
end
