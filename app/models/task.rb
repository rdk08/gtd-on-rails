class Task < ActiveRecord::Base
  validates :description, :presence => true
  validates :task_state_id, :presence => true

  before_save :align_state_data

  belongs_to :project
  belongs_to :category
  belongs_to :task_state

  delegate :state, :to => :task_state
  delegate :state_name, :to => :task_state

  def state=(symbol)
    self.task_state = TaskState.get_object(symbol)
  end

  def complete!
    self.state = :completed
    self.completed_at = Time.now
    save!
  end

  def days_left
    self.date - Date.today
  end

  def self.for(date)
    tasks = {}
    tasks[:done] = Task.completed.done_on(date).sorted_by_hour
    tasks[:to_be_done] = Task.not_completed.to_be_done_on(date).sorted_by_hour
    tasks
  end

  def self.all_within_date_range(from, to)
    tasks = {}
    tasks[:done] = self.completed_within_date_range(from, to)
    tasks[:to_be_done] = self.to_be_done_within_date_range(from, to)
    tasks
  end

  scope :have_to, lambda { where("tasks.have_to is ?", true) }
  scope :sorted_by_hour, lambda { order("tasks.date_hour ASC") }
  scope :today, lambda { where("tasks.date is ?", Date.today) }
  scope :someday_maybe, lambda { where("tasks.have_to is ?", false) }
  scope :done_on, lambda { |date| where("tasks.completed_at like ?", "#{date}%") }
  scope :to_be_done_on, lambda { |date| where("tasks.date is ?", "#{date}") }
  scope :completed_within_date_range, lambda { |from, to|
    where("tasks.completed_at >= ? and tasks.completed_at <= ?", from, to)
  }
  scope :to_be_done_within_date_range, lambda { |from, to|
    joins(:task_state).
    where("task_states.symbol IS NOT ?", :completed).
    where("tasks.date >= ? and tasks.date <= ?", from, to)
  }
  scope :completed, lambda { 
    joins(:task_state).
    where("task_states.symbol IS ?", :completed)
  }
  scope :not_completed, lambda {
    joins(:task_state).
    where("task_states.symbol IS NOT ?", :completed)
  }

  private

    def align_state_data
      if self.state == :completed
        self.completed_at = Time.now
      else
        self.completed_at = nil
      end
    end
end
