require 'test_helper'

class WebPassengersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_passengers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_passenger" do
    assert_difference('WebPassenger.count') do
      post :create, :web_passenger => { }
    end

    assert_redirected_to web_passenger_path(assigns(:web_passenger))
  end

  test "should show web_passenger" do
    get :show, :id => web_passengers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => web_passengers(:one).to_param
    assert_response :success
  end

  test "should update web_passenger" do
    put :update, :id => web_passengers(:one).to_param, :web_passenger => { }
    assert_redirected_to web_passenger_path(assigns(:web_passenger))
  end

  test "should destroy web_passenger" do
    assert_difference('WebPassenger.count', -1) do
      delete :destroy, :id => web_passengers(:one).to_param
    end

    assert_redirected_to web_passengers_path
  end
end
