class BusRoute < ActiveRecord::Base
	# A bus route is the in-between object for bus_stops and routes; It belongs to both, and caches the counter for number of 
	# bus_routes in the bus_stop for easier querying
	belongs_to :bus_stop, counter_cache: true
	belongs_to :route
end
