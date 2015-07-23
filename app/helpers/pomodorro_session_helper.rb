module PomodorroSessionHelper

  def pomodorro_session_exists?
    true if session[:pomodorro_session]
  end

  def pomodorro_session
    session[:pomodorro_session]
  end

  def destroy_pomodorro_session
    session[:pomodorro_session] = nil
  end

  def modify_pomodorro_session(params)
    interval = params[:interval]
    interval_in_seconds = convert_to_seconds(interval)
    session[:pomodorro_session]['time'] -= interval_in_seconds
    session[:pomodorro_session]
  end

  def create_pomodorro_session(params)
    time, task = get_time_and_task(params) 
    return {}, 400 unless task && time
    session[:pomodorro_session] = {'task_description' => task.description, 
                                   'task_id' => task.id, 
                                   'time' => time}
    [session[:pomodorro_session], 200]
  end

  def get_time_and_task(params)
    time = params[:time].to_i
    task_id = params[:task_id].to_i
    task = Task.find(task_id)
    [time, task]
  end

  def convert_to_seconds(interval)
    interval.to_i / 1000
  end

end
