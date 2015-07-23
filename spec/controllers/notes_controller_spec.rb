require "rails_helper"
require 'search_term'

describe NotesController do

  describe "GET #index" do
    let(:note) { double }

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end

    it "displays notes" do
      allow(Note).to receive(:all).and_return([note])
      get :index
      expect(assigns(:notes)).to eq([note])
    end
  end

  describe "GET #new" do let(:note) { double("note") }

    it "assigns note" do
      allow(Note).to receive(:new).and_return(note)
      get :new
      expect(assigns(:note)).to eq note
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    let(:note) { FactoryGirl.create :note }

    it "assigns note" do
      get :show, id: note
      expect(assigns(:note)).to eq note
    end

    it "renders the :show view" do
      get :show, id: note
      expect(response).to render_template :show
    end
  end

  describe "POST #search" do

    context "with provided searched_term parameter" do
      let(:search_term) { instance_double("SearchTerm") }
      let(:note) { double }

      it "responds with code 200" do
        allow(SearchTerm).to receive(:new).and_return(search_term)
        expect(search_term).to receive(:search).and_return([note])
        xhr :post, :search, term: "example"
        expect(response.code).to eq "200"
      end

      it "responds with notes" do
        allow(SearchTerm).to receive(:new).and_return(search_term)
        expect(search_term).to receive(:search).and_return([note])
        xhr :post, :search, term: "example"
        expect(response).to render_template :_notes_rows
      end
    end

    context "when less than three characters are provided as a searched term" do
      let(:note) { double }
      let(:all_items) { [note, note, note] }

      it "returns all items" do
        allow(Note).to receive(:all).and_return(all_items)
        xhr :post, :search, term: "ex"
        expect(assigns(:notes)).to eq all_items
      end
    end

  end

  describe "POST #create" do
    let(:note) { FactoryGirl.attributes_for(:note) }
    let(:note_without_title) { FactoryGirl.attributes_for :note, :without_title }

    context "with provided title attribute" do
      it "saves new note in the database" do
        expect {
          post :create, note: note
        }.to change(Note,:count).by(1)
      end
    end
    
    context "with missing title attribute" do
      it "does not save new note in the database" do
        expect {
          post :create, note: note_without_title
        }.not_to change(Note,:count)
      end

      it "re-renders the :new template" do
        post :create, note: note_without_title
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do

    context "with provided title attribute" do 
      let(:note) { FactoryGirl.create :note, :with_old_title }

      it "updates note" do
        post :update, id: note, note: {:title => 'New title'}
        note.reload
        expect(note.title).to eq 'New title'
      end
    end

    context "with missing title attribute" do 
      let(:note) { FactoryGirl.create :note }

      it "re-renders edit view" do
        post :update, id: note, note: {:title => nil }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let(:note) { FactoryGirl.create :note }

    it "deletes note" do
      delete :destroy, id: note
      expect { note.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
