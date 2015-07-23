require "rails_helper"

describe CalendarController do

  let(:day) { double("Day") }
  
  describe "GET #view" do
    it "renders the :view view" do
      allow(Day).to receive(:days).and_return([])
      get :view
      expect(response).to render_template :view
    end

    it "assigns week data" do
      allow(Day).to receive(:days).and_return([day] * 7)
      get :view
      expect(assigns(:days).length).to eq 7
    end
  end
  
  describe "GET #upcoming_tasks" do
    it "renders the :upcoming_tasks view" do
      allow(Day).to receive(:days_with_tasks).and_return([]) 
      get :upcoming_tasks
      expect(response).to render_template :upcoming_tasks
    end

    it "assigns only days with tasks to be done" do
      allow(Day).to receive(:days_with_tasks_to_be_done).and_return([day])
      get :upcoming_tasks
      expect(assigns(:days).length).to eq 1
    end
  end
end
