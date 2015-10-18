class Note < ActiveRecord::Base
  validates :title, :presence => true

  scope :inbox, lambda { where(archived: false) }
  scope :archived, lambda { where(archived: true) }
end
