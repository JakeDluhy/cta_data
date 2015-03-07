class CreateBusRoutes < ActiveRecord::Migration
  def change
    create_table :bus_routes do |t|
    	t.belongs_to :bus_stop
    	t.belongs_to :route
    	
      t.timestamps
    end
  end
end
