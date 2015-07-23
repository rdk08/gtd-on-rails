require 'rails_helper'

describe Day do

  context "for specific day" do
    let (:today) { Date.today }

    it "has one task assigned if there is one task to be done" do
      task_today = FactoryGirl.create :task, :to_be_done_today
      task_tomorrow = FactoryGirl.create :task, :to_be_done_tomorrow
      day = Day.new(today) do |d|
        d.tasks = Task.for(d.date)
      end
      expect(day.tasks[:to_be_done].count).to eq 1
    end

    it "has no assigned tasks if there are no tasks to be done" do
      task_tomorrow = FactoryGirl.create :task, :to_be_done_tomorrow
      day = Day.new(today) do |d|
        d.tasks = Task.for(d.date)
      end
      expect(day.tasks[:to_be_done].count).to eq 0
    end

    it "has one task assigned if one task was done" do
      task = FactoryGirl.create :task, :done_today
      day = Day.new(today) do |d|
        d.tasks = Task.for(d.date)
      end
      expect(day.tasks[:done].count).to eq 1
    end

    it "has no assigned tasks if no tasks have been done" do
      day = Day.new(today) do |d|
        d.tasks = Task.for(d.date)
      end
      expect(day.tasks[:done].count).to eq 0
    end
  end

  context "for days range" do
    let (:beginning_of_week) { Date.today.beginning_of_week }
    let (:end_of_week) { Date.today.end_of_week }
    let (:days_range) { { start_date: beginning_of_week, end_date: end_of_week } }

    it "returns multiple days" do
      days = Day.days(days_range[:start_date], days_range[:end_date])
      expect(days.count).to eq 7
    end

    it "returns only days with tasks" do
      task = FactoryGirl.create :task, :have_to
      task.date = Date.today
      task.save
      days = Day.days_with_tasks(days_range[:start_date], days_range[:end_date])
      expect(days.count).to eq 1
    end

    context "when looking only for days with tasks to be done" do

      it "returns days" do
        task = FactoryGirl.create :task, :to_be_done_today
        task = FactoryGirl.create :task, :to_be_done_tomorrow

        days = Day.days_with_tasks_to_be_done(days_range[:start_date], days_range[:end_date])
        expect(days.count).to eq 2
      end

      it "does not return days if there are only tasks already done" do
        task = FactoryGirl.create :task, :done_today

        days = Day.days_with_tasks_to_be_done(days_range[:start_date], days_range[:end_date])
        expect(days.count).to eq 0
      end
    end
  end
end
