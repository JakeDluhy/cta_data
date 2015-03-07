class BusStopsController < ApplicationController
  # Action takes in on_street and cross_street in the params, and returns a bus stop at the location
  def streets
    street = params[:on_street]
    cross_street = params[:cross_street]
    stop = BusStop.where('on_street = ? AND cross_street = ?', street, cross_street).includes(:location).first
    unless stop.nil?
      render :json => stop.to_json(:include => [:location, :routes])
    else
      render :json => {error: 'Stop not found'}.to_json
    end
  end

  # Action takes in number, order, and filter and returns the corresponding stops
  def multi_stops
    number = params[:number]
    order = params[:order]
    filter = params[:filter]

    stops = BusStop.order("#{filter} #{order}").limit(number).includes(:location)

    render :json => stops.to_json(:include => [:location, :routes])
  end

  # Action to get a list of streets and cross streets for the autocomplete method
  def all_stops
    on_streets = BusStop.select('on_street').distinct
    cross_streets = BusStop.select('cross_street').distinct
    # Map actiee record objects to arrays
    on_streets.map! {|s| s.on_street}
    cross_streets.map! {|s| s.cross_street}
    # Create a json structure
    response = {
      'on_streets' => on_streets.to_json,
      'cross_streets' => cross_streets.to_json
    }
    render :json => response
  end
end
