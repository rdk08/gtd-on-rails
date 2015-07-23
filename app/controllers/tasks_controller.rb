class TasksController < ApplicationController
  include ApplicationHelper
  include TasksHelper

  before_action :set_task, except: [:index, :create, :new]
  before_action :set_last_visited, only: [:show, :index]

  def index
    view = params[:view] || session[:view]
    @tasks = get_tasks_for(view)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to last_visited || { :action => 'index' }
    else
      render :new
    end
  end

  def show
    render :show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def complete
    @task.complete!
    flash[:notice] = 'Task marked as completed.'
    redirect_to last_visited || { :action => 'index' }
  end

  def update
    if @task.update(task_params)
      flash[:notice] = 'Task was successfully updated.'
      redirect_to last_visited || { :action => 'index' }
    else
      render :edit
    end
  end
  
  def destroy
    @task.destroy!
    flash[:notice] = 'Task was deleted.'
    if destroying_displayed_resource?
      redirect_to :action => 'index'
    else
      redirect_to last_visited || { :action => 'index' }
    end
  end

  def completed_pomodorro
    @task.pomodorro_sessions ||= 0
    @task.pomodorro_sessions += 1
    if @task.save
      render json: {}, status: 200
    else
      render json: {}, status: 500
    end
  end

  private

    def task_params
      params.require(:task).permit(:description, :have_to, :task_state_id, :project_id, :date, :date_hour, :date_due, :pomodorro_sessions, :additional_info)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
