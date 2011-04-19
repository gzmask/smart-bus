require 'test_helper'

class WebLocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_location" do
    assert_difference('WebLocation.count') do
      post :create, :web_location => { }
    end

    assert_redirected_to web_location_path(assigns(:web_location))
  end

  test "should show web_location" do
    get :show, :id => web_locations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => web_locations(:one).to_param
    assert_response :success
  end

  test "should update web_location" do
    put :update, :id => web_locations(:one).to_param, :web_location => { }
    assert_redirected_to web_location_path(assigns(:web_location))
  end

  test "should destroy web_location" do
    assert_difference('WebLocation.count', -1) do
      delete :destroy, :id => web_locations(:one).to_param
    end

    assert_redirected_to web_locations_path
  end
end
