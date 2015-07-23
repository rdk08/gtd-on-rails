require 'rails_helper'

describe Project do

  it "changes state to completed" do
    project = FactoryGirl.create :project
    project.complete!

    expect(project.state).to eq :completed
    expect(project.completed_at).not_to eq nil
  end

end
