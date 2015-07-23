require 'search_term' 

class NotesController < ApplicationController
  include ApplicationHelper

  before_action :set_note, only: [:destroy, :update, :edit, :show]
  before_action :set_last_visited, only: [:show, :index]

  def index
    @notes = Note.all
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      flash[:notice] = 'Note was successfully created.'
      redirect_to last_visited || { :action => 'index' }
    else
      render :new
    end
  end
  
  def show
    render :show
  end

  def search
    format.js { render :nothing => true, :status => 400 } unless params[:term]
    respond_to do |format|
      @notes = params[:term].length > 2 ? search_by_term(params[:term], Note.all) : Note.all
      format.js { render :_notes_rows }
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
      flash[:notice] = 'Note was successfully updated.'
      redirect_to :action => 'index'
    else
      render :edit
    end
  end

  def new
    @note = Note.new
  end

  def destroy
    @note.destroy!
    flash[:notice] = 'Note was deleted.'
    if destroying_displayed_resource?
      redirect_to :action => 'index'
    else
      redirect_to last_visited || { :action => 'index' }
    end
  end

  private

    def search_by_term(term, scope)
      search_term = SearchTerm.new(:max_results => 15,
                                   :scope => scope,
                                   :matching_scores => {:title => 3, :body => 1})
      search_term.search(term)
    end

    def note_params
      params.require(:note).permit(:title, :body)
    end

    def search_params
      params.permit(:searched_term)
    end

    def set_note
      @note = Note.find(params[:id])
    end
end
