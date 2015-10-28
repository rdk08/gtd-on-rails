class ListsController < ApplicationController
  include ApplicationHelper

  before_action :set_list, only: [:destroy, :complete, :update, :edit, :show]
  before_action :set_last_visited, only: [:show, :index]

  def index
    view = params[:view] || session[:view]
    @lists = List.all
  end

  def show
    render :show
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      flash[:notice] = 'List was successfully created.'
      redirect_to last_visited || {:action => 'index'}
    else
      render :new
    end
  end

  def destroy
    @list.destroy!
    flash[:notice] = 'List was deleted.'
    if destroying_displayed_resource?
      redirect_to :action => 'index'
    else
      redirect_to last_visited || { :action => 'index' }
    end
  end

  def update
    if @list.update(list_params)
      flash[:notice] = 'List was successfully updated.'
      redirect_to :action => 'index'
    else
      render :edit
    end
  end

  private

    def list_params
      params.require(:list).permit(:name)
    end

    def set_list
      @list = List.find(params[:id])
    end

end
