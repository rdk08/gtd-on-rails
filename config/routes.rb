Rails.application.routes.draw do

  root 'tasks#index'

  resources :tasks
  resources :projects
  resources :notes
  resources :sessions, only: [:new, :create, :destroy]
  resources :breaks, only: [:create, :update, :destroy]
  
  # Custom paths
  
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  
  get 'tasks?view=have_to' => 'tasks#index', as: :tasks_have_to
  get 'tasks?view=someday_maybe' => 'tasks#index', as: :tasks_someday_maybe
  get 'tasks?view=all' => 'tasks#index', as: :tasks_all
  get 'tasks?view=completed' => 'tasks#index', as: :tasks_completed
  get 'tasks/:id/complete' => 'tasks#complete', as: :complete_task
  patch 'tasks/:id/completed_pomodorro' => 'tasks#completed_pomodorro', as: :completed_pomodorro

  get 'projects/:id/complete' => 'projects#complete', as: :complete_project
  get 'projects?view=active' => 'projects#index', as: :projects_active
  get 'projects?view=freezed' => 'projects#index', as: :projects_freezed
  get 'projects?view=all' => 'projects#index', as: :projects_all
  get 'projects?view=completed' => 'projects#index', as: :projects_completed

  get 'calendar' => 'calendar#view'
  get 'calendar/week' => 'calendar#view'
  get 'calendar/week?date=:date' => 'calendar#view'
  get 'calendar/upcoming_tasks' => 'calendar#upcoming_tasks'

  post 'notes/search' => 'notes#search'

  get 'pomodorro_session' => 'pomodorro_session#show'
  post 'pomodorro_session' => 'pomodorro_session#create'
  patch 'pomodorro_session' => 'pomodorro_session#update'
  delete 'pomodorro_session' => 'pomodorro_session#destroy'

end
