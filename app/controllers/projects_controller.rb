class ProjectsController < ApplicationController
  include ApplicationHelper
  include ProjectsHelper

  before_action :set_project, only: [:destroy, :complete, :update, :edit, :show]
  before_action :set_last_visited, only: [:show, :index]

  def index
    view = params[:view] || session[:view]
    @projects = get_projects_for(view)
  end

  def show
    render :show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to last_visited || {:action => 'index'}
    else
      render :new
    end
  end

  def destroy
    @project.destroy!
    flash[:notice] = 'Project was deleted.'
    redirect_to last_visited || {:action => 'index'}
  end

  def complete
    @project.complete!
    flash[:notice] = 'Project was successfully completed.'
    redirect_to last_visited || {:action => 'index'}
  end

  def update
    if @project.update(project_params)
      flash[:notice] = 'Project was successfully updated.'
      redirect_to :action => 'index'
    else
      render :edit
    end
  end

  private

    def project_params
      params.require(:project).permit(:name, :goal_description, :hard_deadline, :soft_deadline, :project_state_id)
    end

    def set_project
      @project = Project.find(params[:id])
    end

end
