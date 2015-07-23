require 'rails_helper'

RSpec.describe PomodorroSessionController, type: :controller do
  let(:task) { instance_double('Task', :description => 'Task description', :id => 1) }
  let(:session_time) { 1500 }

  describe "#create" do
    let(:passed_params) { {task_id: task.id, time: session_time} }
    let(:expected_response) { {'time' => session_time, 
                               'task_id' => task.id, 
                               'task_description' => task.description} }

    it "responds with code 200" do
      allow(Task).to receive(:find).and_return(task)
      get :create, passed_params, {'Accept': 'application/json'}
      expect(response.status).to eq 200
    end

    it "initiates pomodorro session" do
      allow(Task).to receive(:find).and_return(task)
      get :create, passed_params, {'Accept': 'application/json'}
      expect(session[:pomodorro_session]).to eq expected_response
    end
  end

  describe "#destroy" do
    context "when pomodorro session exists" do
      before { session[:pomodorro_session] = {'time' => session_time, 
                                              'task_id' => task.id, 
                                              'task_description' => task.description} }

      it "responds with code 200" do
        delete :destroy, {}, {'Accept': 'application/json'}
        expect(response.status).to eq 200
      end

      it "destroys pomodorro session" do
        delete :destroy, {}, {'Accept': 'application/json'}
        expect(session[:pomodorro_session]).to eq nil
      end
    end

    context "when pomodorro session does not exist" do
      before { session[:pomodorro_session] = nil }

      it "responds with code 400" do
        delete :destroy, {}, {'Accept': 'application/json'}
        expect(response.status).to eq 400
      end
    end
  end

  describe "#show" do
    before { session[:pomodorro_session] = {'time' => session_time, 
                                            'task_id' => task.id, 
                                            'task_description' => task.description} }
    let(:expected_response) { {'time' => session_time, 
                               'task_id' => task.id, 
                               'task_description' => task.description} }

    it "responds with code 200" do
      get :show, {}, {'Accept': 'application/json'}
      expect(response.status).to eq 200
    end

    it "fetches current pomodorro session data" do
      get :show, {}, {'Accept': 'application/json'}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq expected_response
    end
  end

  describe "#update" do
      before { session[:pomodorro_session] = {'time' => session_time, 
                                              'task_id' => task.id, 
                                              'task_description' => task.description} }
      let(:expected_response) { {'time' => 1485, 
                                 'task_id' => task.id, 
                                 'task_description' => task.description} }
      let(:passed_params) { {interval: 15000} }

      it "substract session time by interval value" do
        get :update, passed_params, {'Accept': 'application/json'}
        expect(session[:pomodorro_session]['time']).to eq 1485
      end

      it "returns JSON object with time left and task description" do
        get :update, passed_params, {'Accept': 'application/json'}
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq expected_response
      end
    end
end
