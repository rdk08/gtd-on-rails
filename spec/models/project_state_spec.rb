require 'rails_helper'

describe ProjectState do
  let (:project_state) { FactoryGirl.create :project_state, :completed }

  it "returns state symbol" do
    expect(project_state.state).to eq :completed
  end

end
