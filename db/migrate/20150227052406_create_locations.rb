class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :human_address
      t.string :latitude
      t.string :longitude
      t.string :machine_address
      t.boolean :needs_recording
      t.belongs_to :bus_stop, index: true

      t.timestamps
    end
  end
end
