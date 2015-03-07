class Location < ActiveRecord::Base
	#Location object refering to a bus stop
	belongs_to :bus_stop
end
