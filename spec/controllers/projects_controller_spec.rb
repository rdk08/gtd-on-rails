require "rails_helper"

describe ProjectsController do

  describe "GET #index" do
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
    
    it "displays projects" do
      project = FactoryGirl.create :project
      get :index
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe "GET #index view" do
    let(:project_active) { FactoryGirl.create :project, :active }
    let(:project_freezed) { FactoryGirl.create :project, :freezed }
    let(:project_completed) { FactoryGirl.create :project, :completed }

    it "displays active projects" do
      get :index, :view => 'active'
      expect(assigns(:projects)).to include project_active
      expect(assigns(:projects)).not_to include project_freezed
      expect(assigns(:projects)).not_to include project_completed
    end

    it "displays freezed projects" do
      get :index, :view => 'freezed'
      expect(assigns(:projects)).to include project_freezed
      expect(assigns(:projects)).not_to include project_active
      expect(assigns(:projects)).not_to include project_completed
    end

    it "displays completed projects" do
      get :index, :view => 'completed'
      expect(assigns(:projects)).to include project_completed
      expect(assigns(:projects)).not_to include project_active
      expect(assigns(:projects)).not_to include project_freezed
    end
  end

  describe "GET #new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    it "renders the :show view" do
      project = FactoryGirl.create :project
      get :show, id: project
      expect(response).to render_template :show
    end
  end

  describe "POST #create" do
    let(:project) { FactoryGirl.attributes_for(:project) }

    context "with valid attributes" do
      before(:each) { project[:project_state_id] = 1 }

      it "saves the new project in database" do
        expect {
          post :create, project: project
        }.to change(Project,:count).by(1)
      end

      it "redirects to the index page" do
        post :create, project: project
        expect(response).to redirect_to :action => 'index'
      end
    end

    context "with invalid attributes" do
      before(:each) { project[:project_state_id] = nil }

      it "does not save the new project in database" do
        expect {
          post :create, project: project
        }.not_to change(Project,:count)
      end

      it "re-renders the :new template" do
        post :create, project: project
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do 
      it "updates project" do
        project = FactoryGirl.create :project, :name => 'Before'
        post :update, id: project, project: {:name => 'After'}
        project.reload
        expect(project.name).to eq 'After'
      end
    end

    context "with invalid attributes" do 
      it "re-renders edit view" do
        project = FactoryGirl.create :project, :name => 'Before'
        post :update, id: project, project: {:name => nil }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes project" do
      project = FactoryGirl.create :project
      delete :destroy, id: project
      expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #complete" do
    it "completes project" do
      project = FactoryGirl.create :project
      get :complete, id: project
      project = Project.find(project.id)
      expect(project.state).to eq :completed
    end
  end
end
