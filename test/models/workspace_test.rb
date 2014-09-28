require "test_helper"

describe Workspace do
  let(:workspace) { Workspace.new }

  it "must be valid" do
    workspace.must_be :valid?
  end
end
