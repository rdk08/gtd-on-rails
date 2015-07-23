require "rails_helper"

describe TasksController do
  
  describe "GET #index" do
    let(:task) { FactoryGirl.create :task }
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end

    it "displays tasks" do
      get :index
      expect(assigns(:tasks)).to eq([task])
    end
  end
  
  describe "GET #index with have_to view" do
    let(:task_have_to) { FactoryGirl.create :task, :have_to }
    let(:task_someday_maybe) { FactoryGirl.create :task, :someday_maybe } 

    it "displays tasks with have to flag turned on" do
      get :index, :view => 'have_to'
      expect(assigns(:tasks)).to include task_have_to
      expect(assigns(:tasks)).not_to include task_someday_maybe
    end

    it "displays tasks with have to flag turned on" do
      get :index, :view => 'someday_maybe'
      expect(assigns(:tasks)).to include task_someday_maybe
      expect(assigns(:tasks)).not_to include task_have_to
    end
  end

  describe "GET #new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    let(:task) { FactoryGirl.create :task }
    it "renders the :show view" do
      get :show, id: task
      expect(response).to render_template :show
    end
  end
  
  describe "POST #create" do
    let(:task) { FactoryGirl.attributes_for(:task) }

    context "with assigned task state attribute" do
      before(:each) { task[:task_state_id] = TaskState.get_object(:pending).id }

      it "saves new task in the database" do
        expect {
          post :create, task: task
        }.to change(Task,:count).by(1)
      end
    end
    
    context "with missing task state attribute" do
      before(:each) { task[:task_state_id] = nil }

      it "does not save new task in the database" do
        expect {
          post :create, task: task
        }.not_to change(Task,:count)
      end

      it "re-renders the :new template" do
        post :create, task: task
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT #update" do
    let(:task) { FactoryGirl.create :task, :have_to, :description => 'Before' }

    context "with specified required attributes" do 
      it "updates task" do
        post :update, id: task, task: {:description => 'After'}
        task.reload
        expect(task.description).to eq 'After'
      end
    end

    context "with missing attribute" do 
      it "re-renders edit view" do
        post :update, id: task, task: {:description => nil }
        expect(response).to render_template :edit
      end
    end
  end
  
  describe "DELETE #destroy" do
    let(:task) { FactoryGirl.create :task, :have_to }

    it "deletes task" do
      delete :destroy, id: task
      expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #complete" do
    let(:task) { FactoryGirl.create :task, :have_to }

    it "completes task" do
      get :complete, id: task
      t = Task.find(task.id)
      expect(t.state).to eq :completed
    end
  end

  describe "PATCH #completed_pomodorro" do
    let(:task) { FactoryGirl.create :task, :have_to }
    before { task.pomodorro_sessions = 0 }

    it "increments pomodorro session counter for task" do
      patch :completed_pomodorro, id: task
      t = Task.find(task.id)
      expect(t.pomodorro_sessions).to eq 1
    end
  end
end
