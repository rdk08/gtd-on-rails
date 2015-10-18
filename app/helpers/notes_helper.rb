module NotesHelper

  def get_notes_for(view)
    case view
      when "inbox" then Note.inbox
      when "archived" then Note.archived
      else Note.inbox
    end
  end

end
