class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.integer :stop_id
      t.string :on_street
      t.string :cross_street
      t.integer :bus_routes_count, default: 0
      t.decimal :boardings
      t.decimal :alightings
      t.date :month_beginning
      t.string :daytype

      t.timestamps
    end
  end
end
