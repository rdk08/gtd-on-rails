class PomodorroSessionController < ApplicationController
  include PomodorroSessionHelper

  def create
    if params_required_for_creation
      response, status = create_pomodorro_session(permitted_params)
      render json: response, status: status
    else
      render json: {}, status: 400
    end
  end
  
  def show
    response = pomodorro_session || {}
    render json: response, status: 200
  end
  
  def destroy
    if pomodorro_session_exists?
      destroy_pomodorro_session
      render json: {}, status: 200
    else
      render json: {}, status: 400
    end

  end
  
  def update
    if pomodorro_session_exists? && params_required_for_update
      response = modify_pomodorro_session(permitted_params)
      render json: response, status: 200
    else
      render json: {}, status: 200 
    end
  end

  private

    def permitted_params
      params.permit(:task_id, :time, :interval)
    end

    def params_required_for_creation
      permitted_params[:task_id] && permitted_params[:time] 
    end

    def params_required_for_update
      permitted_params[:interval]
    end

end
