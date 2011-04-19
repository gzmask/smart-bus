require 'test_helper'

class WebBusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_buses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_bus" do
    assert_difference('WebBus.count') do
      post :create, :web_bus => { }
    end

    assert_redirected_to web_bus_path(assigns(:web_bus))
  end

  test "should show web_bus" do
    get :show, :id => web_buses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => web_buses(:one).to_param
    assert_response :success
  end

  test "should update web_bus" do
    put :update, :id => web_buses(:one).to_param, :web_bus => { }
    assert_redirected_to web_bus_path(assigns(:web_bus))
  end

  test "should destroy web_bus" do
    assert_difference('WebBus.count', -1) do
      delete :destroy, :id => web_buses(:one).to_param
    end

    assert_redirected_to web_buses_path
  end
end
