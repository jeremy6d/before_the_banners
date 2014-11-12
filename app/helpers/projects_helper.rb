module ProjectsHelper
  def workspace_filter_class_for workspace
    if current? workspace 
      "selected"
    else
      "unselected"
    end
  end

  def workspace_filter_path workspace
    if current? workspace 
      project_path 
    else
      project_path(@project, workspace: workspace.slug)
    end
  end

  def current? workspace
    workspace == @current_workspace
  end
end
