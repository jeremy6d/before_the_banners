require "test_helper"

describe UpdatesController do

  let(:update) { updates :one }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:updates)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates update" do
    assert_difference('Update.count') do
      post :create, update: {  }
    end

    assert_redirected_to update_path(assigns(:update))
  end

  it "shows update" do
    get :show, id: update
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: update
    assert_response :success
  end

  it "updates update" do
    put :update, id: update, update: {  }
    assert_redirected_to update_path(assigns(:update))
  end

  it "destroys update" do
    assert_difference('Update.count', -1) do
      delete :destroy, id: update
    end

    assert_redirected_to updates_path
  end

end
