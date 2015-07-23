require 'rails_helper'

describe Task do
  
  let (:task) { FactoryGirl.create :task }
  let (:task_completed) { FactoryGirl.create :task, :completed }
  let (:state_completed) { FactoryGirl.create :task_state, :completed }
  let (:state_pending) { FactoryGirl.create :task_state, :pending }

  it "changes state to completed" do
    task.complete!

    expect(task.state).to eq :completed
    expect(task.completed_at).not_to eq nil
  end

  it "returns tasks within given date range" do
    task = FactoryGirl.create :task, :to_be_done_tomorrow
    task = FactoryGirl.create :task, :done_today

    tasks = Task.all_within_date_range(Date.today, Date.tomorrow)
    expect(tasks[:done].count).to eq 1
    expect(tasks[:to_be_done].count).to eq 1
  end

  it "aligns state when changed to completed" do
    task.update!(task_state: state_completed)

    expect(task.state).to eq :completed
    expect(task.completed_at).not_to eq nil
  end

  it "aligns state when changed from completed" do
    task_completed.update!(task_state: state_pending)

    expect(task.state).to eq :pending
    expect(task.completed_at).to eq nil
  end

end
