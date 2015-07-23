module ProjectsHelper
  
  def get_projects_for(view)
    case view
      when "active" then Project.not_completed.active
      when "freezed" then Project.not_completed.freezed
      when "all" then Project.not_completed.all
      when "completed" then Project.completed
      else Project.not_completed.all
    end
  end

  def counter(projects)
    projects.count if projects
  end

  def link_to_project(project)
    if project.state == :completed
      raw("<span class='line-through'>#{link_to(project.name, project_path(project))}</span>")
    else
      raw(link_to(project.name, project_path(project)))
    end
  end
end
