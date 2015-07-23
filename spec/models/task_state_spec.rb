require 'rails_helper'

describe TaskState do
  let (:task_state) { FactoryGirl.create :task_state, :completed }

  it "returns state symbol" do
    expect(task_state.state).to eq :completed
  end

end
