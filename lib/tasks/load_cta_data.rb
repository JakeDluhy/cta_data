require 'active_record'
require 'pg'
require 'json'

# Establish Connection to Database
begin
	ActiveRecord::Base.establish_connection(
		adapter: 'postgresql',
		database: 'civis_db',
  	host: 'localhost'
	)
# Catch argument exception
rescue ArgumentError => e
	# Log error to the console
	puts e
end

#Create Models with same relationships as those the app
# See models in app for relationship explanation
class BusStop < ActiveRecord::Base
	has_one :location
	has_many :bus_routes
	has_many :routes, :through => :bus_routes
end
class Location < ActiveRecord::Base
	belongs_to :bus_stop
end
class BusRoute < ActiveRecord::Base
	belongs_to :bus_stop, counter_cache: true
	belongs_to :route
end
class Route < ActiveRecord::Base
	has_many :bus_routes
	has_many :bus_stops, :through => :bus_routes
end

# Check to see if there are already entries in the database. If there are, raise an exception to let the user know
unless BusStop.first.nil?
	raise 'There are already entries in the table. Take care not to create duplicates. Recommended course of action is to reset the DB'
end

#Load the CTA data from the assets file in lib and parse it into a hash
cta_data = JSON.parse(File.read('../assets/cta_ridership.json'))

# Iterate over each entry, entering it into the database
cta_data["data"].each do |data_entry|
	# Create new Bus Stop entry
	new_stop = BusStop.new({
		stop_id: data_entry[8],
		on_street: data_entry[9],
		cross_street: data_entry[10],
		boardings: data_entry[12],
		alightings: data_entry[13],
		month_beginning: data_entry[14],
		daytype: data_entry[15]
	})

	# Save entry. If false break out of the enum for finer error handling
	if new_stop.save
		#Check whether routes field in nil or not
		unless data_entry[11].nil?
			#If not nil, split the string into multiple stops to be created into objects
			data_entry[11].split(',').each do |route|
				#Search for the route
				existing_route = Route.find_by_route_id(route)
				#If the route doesn't exist, create a new one, and save it with an associated bus route
				if existing_route.nil?
					new_route = Route.new({route_id: route})
					if new_route.save
						BusRoute.create({route_id: new_route.id, bus_stop_id: new_stop.id})
					else
						puts 'Save error with new route'
					end
				else
					#If the route does exist, create a bus route for the existing route
					BusRoute.create({route_id: existing_route.id, bus_stop_id: new_stop.id})
				end
			end
		end

		# Create a new loaction referencing saved stop
		new_location = Location.new({
			human_address: data_entry[16][0],
			latitude: data_entry[16][1],
			longitude: data_entry[16][2],
			machine_address: data_entry[16][3],
			needs_recording: data_entry[16][4],
			bus_stop_id: new_stop.id
		})

		# Save and break on error
		if new_location.save
			puts "Success. BusStop Id = #{new_stop.id}"
		else
			puts 'Save error with new location'
			break
		end
	else
		puts 'Save error with New Stop'
		break
	end
end
puts 'Finished'