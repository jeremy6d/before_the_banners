require_relative '../test_helper'

describe "Update" do
  describe "running validations" do
    subject { Fabricate.build :update }
    
    it "requires a workspace" do
      subject.workspace = nil
      subject.wont_be :valid?
      subject.errors[:workspace].must_include "can't be blank"
    end
  end
end