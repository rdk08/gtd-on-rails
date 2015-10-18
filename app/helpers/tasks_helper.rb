module TasksHelper

  def get_tasks_for(view)
    case view
      when "have_to" then Task.not_completed.have_to
      when "someday_maybe" then Task.not_completed.someday_maybe
      when "all" then Task.not_completed.all
      when "completed" then Task.completed
      else Task.not_completed.have_to
    end
  end

  def format_date(date)
    date.strftime("%d-%m-%Y")
  end

  def counter(tasks)
    tasks.count if tasks
  end

  def link_to_task(task)
    if task.state == :completed
      raw("<span class='line-through'>#{link_to(task.description, task_path(task))}</span>")
    else
      raw(link_to(task.description, task_path(task)))
    end
  end
end
