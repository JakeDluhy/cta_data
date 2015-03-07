require 'test_helper'

class BusStopsControllerTest < ActionController::TestCase
  setup do
    @bus_stop = bus_stops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bus_stops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bus_stop" do
    assert_difference('BusStop.count') do
      post :create, bus_stop: { alightings: @bus_stop.alightings, boardings: @bus_stop.boardings, cross_street: @bus_stop.cross_street, daytype: @bus_stop.daytype, month_beginning: @bus_stop.month_beginning, on_street: @bus_stop.on_street, routes: @bus_stop.routes, stop_id: @bus_stop.stop_id }
    end

    assert_redirected_to bus_stop_path(assigns(:bus_stop))
  end

  test "should show bus_stop" do
    get :show, id: @bus_stop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bus_stop
    assert_response :success
  end

  test "should update bus_stop" do
    patch :update, id: @bus_stop, bus_stop: { alightings: @bus_stop.alightings, boardings: @bus_stop.boardings, cross_street: @bus_stop.cross_street, daytype: @bus_stop.daytype, month_beginning: @bus_stop.month_beginning, on_street: @bus_stop.on_street, routes: @bus_stop.routes, stop_id: @bus_stop.stop_id }
    assert_redirected_to bus_stop_path(assigns(:bus_stop))
  end

  test "should destroy bus_stop" do
    assert_difference('BusStop.count', -1) do
      delete :destroy, id: @bus_stop
    end

    assert_redirected_to bus_stops_path
  end
end
