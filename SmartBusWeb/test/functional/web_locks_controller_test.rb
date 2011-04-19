require 'test_helper'

class WebLocksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_locks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_lock" do
    assert_difference('WebLock.count') do
      post :create, :web_lock => { }
    end

    assert_redirected_to web_lock_path(assigns(:web_lock))
  end

  test "should show web_lock" do
    get :show, :id => web_locks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => web_locks(:one).to_param
    assert_response :success
  end

  test "should update web_lock" do
    put :update, :id => web_locks(:one).to_param, :web_lock => { }
    assert_redirected_to web_lock_path(assigns(:web_lock))
  end

  test "should destroy web_lock" do
    assert_difference('WebLock.count', -1) do
      delete :destroy, :id => web_locks(:one).to_param
    end

    assert_redirected_to web_locks_path
  end
end
