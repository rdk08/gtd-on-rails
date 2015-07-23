class CalendarController < ApplicationController
  include ApplicationHelper
  include CalendarHelper
  before_action :set_last_visited, :set_date
  
  def view
    @days = get_week_data_for(@date)
    @week = { :prev => @date.prev_week, 
              :next => @date.next_week }
  end

  def upcoming_tasks
    @days = get_days_with_tasks_for_next(90)
  end

  private 

    def get_week_data_for(date)
      Day.days(date.beginning_of_week, date.end_of_week)
    end

    def get_days_with_tasks_for_next(number_of_days)
      Day.days_with_tasks_to_be_done(Date.today, number_of_days.days.from_now)
    end

    def set_date
      @date = parse(params[:date]) if params[:date]
      @date ||= Date.today
    end

end
