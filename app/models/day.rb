class Day
  attr_accessor :date, :tasks

  def initialize(date, &tasks_assignment) 
    @date = date
    @tasks = {done: [], to_be_done: []}
    tasks_assignment.call(self) if block_given?
  end

  def assign_task(type, task)
    @tasks[type] << task
  end

  def self.days(from, to)
    days = []
    current_date = from
    begin
      days << Day.new(current_date) { |day| day.tasks = Task.for(day.date) }
      current_date = current_date.next_day
    end while current_date <= to
    days
  end

  def self.days_with_tasks(from, to)
    tasks = Task.all_within_date_range(from, to)
    days = {}
    tasks.each_key { |type| days = create_days_based_on_tasks(days, type, tasks[type]) }
    days.values
  end

  def self.days_with_tasks_to_be_done(from, to)
    days = days_with_tasks(from, to)
    days = days.select { |day| day if day.tasks[:to_be_done].any? }
    days
  end

  def self.create_days_based_on_tasks(days, type, tasks)
    tasks.each do |task|
      date = task.state == :completed ? task.completed_at.to_date : task.date
      days[date] ||= Day.new(date)
      days[date].assign_task(type, task)
    end
    days
  end

  private_class_method :create_days_based_on_tasks

end
