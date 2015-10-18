class Project < ActiveRecord::Base
  validates :name, :presence => true
  validates :project_state_id, :presence => true

  belongs_to :project_state
  has_many :tasks, -> { order(:task_state_id => :desc) }

  before_save :align_state_data

  delegate :state, :to => :project_state
  delegate :state_name, :to => :project_state

  def state=(symbol)
    self.project_state = ProjectState.get_object(symbol)
  end

  def complete!
    self.state = :completed
    self.completed_at = Time.zone.now
    save!
  end

  def percent_done
    100 * (tasks.completed.count.to_f / tasks.count.to_f)
  end

  default_scope { order(name: :asc) }
  scope :active, lambda {
    joins(:project_state).
    where("project_states.symbol is ?", :active)
  }
  scope :freezed, lambda {
    joins(:project_state).
    where("project_states.symbol is ?", :freezed)
  }
  scope :completed, lambda {
    joins(:project_state).
    where("project_states.symbol is ?", :completed)
  }
  scope :not_completed, lambda {
    joins(:project_state).
    where("project_states.symbol is not ?", :completed)
  }

  private

    def align_state_data
      if self.state == :completed
        self.completed_at = Time.now
      else
        self.completed_at = nil
      end
    end

end
