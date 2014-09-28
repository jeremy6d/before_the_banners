require "test_helper"

describe WorkspacesController do

  let(:workspace) { workspaces :one }

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workspaces)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates workspace" do
    assert_difference('Workspace.count') do
      post :create, workspace: {  }
    end

    assert_redirected_to workspace_path(assigns(:workspace))
  end

  it "shows workspace" do
    get :show, id: workspace
    assert_response :success
  end

  it "gets edit" do
    get :edit, id: workspace
    assert_response :success
  end

  it "updates workspace" do
    put :update, id: workspace, workspace: {  }
    assert_redirected_to workspace_path(assigns(:workspace))
  end

  it "destroys workspace" do
    assert_difference('Workspace.count', -1) do
      delete :destroy, id: workspace
    end

    assert_redirected_to workspaces_path
  end

end
