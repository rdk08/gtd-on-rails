module CalendarHelper

  def task_link_for_calendar(task)
    css_classes = "btn btn-calendar btn-xs "
    css_class_done = "btn-success"
    css_class_to_be_done = "btn-to-be-done"
    link_description = " #{task.date_hour} #{task.description} "

    if task.state == :completed
      css_classes << css_class_done
    else
      css_classes << css_class_to_be_done
      link_description.prepend(raw(fa_icon("arrow-circle-o-right"))) if task.have_to && task.date_due
      link_description.prepend(raw(fa_icon("question-circle"))) unless task.have_to
    end

    link_to raw(link_description), task_path(task), :class => css_classes
  end

  def parse(date)
    Date.strptime(params[:date], "%Y-%m-%d")
  end
  
  def format_date_for_calendar(day)
    day.date.strftime("%A %d-%m-%Y")
  end

  def format_date_for_upcoming_task(day)
    "#{day.date} | #{day.date.strftime('%A')}" + br
  end
  
  def br
    raw("<br />")
  end

end
