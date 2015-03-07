class StaticPagesController < ApplicationController
  def home
    @on_streets = BusStop.select('on_street').distinct
    @cross_streets = BusStop.select('cross_street').distinct
    gon.on_streets = @on_streets.map {|s| s.on_street}
    gon.cross_streets = @cross_streets.map {|s| s.cross_street}
  end
end
