class Route < ActiveRecord::Base
	# Route are the individual routes in the city of chicago. Each one has many stops through the bus routes.
	has_many :bus_routes
	has_many :bus_stops, :through => :bus_routes
end
