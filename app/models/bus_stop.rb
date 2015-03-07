class BusStop < ActiveRecord::Base
	# Bus stop is the main object in the database. It has an associated location and many associated routes
	has_one :location
	has_many :bus_routes
	has_many :routes, :through => :bus_routes
end
