module FeatureHelpers
  module ProjectHelpers
    def edit_project! project = nil
      unless project.nil?
        find("header").click_on "My projects"
        find("ul li#project-#{project.to_param}").click
      end

      find("ul.operations.off--page").hover
      click_on "Edit"
    end

    def add_update_to! project, in_attrs = {}
      click_on "My projects"
      
      click_on project.title

      find("ul.operations.off--page").hover
      find("a", text: "Add update").trigger("click") # workaround partial input blockage from popup

      attrs = Fabricate.attributes_for(:update).tap do |a|
        a.merge! in_attrs
        a.delete("author_id")
      end
    id = attrs.delete('workspace_id')
    title = if name = attrs.delete('workspace')
      attrs.delete 'workspace_id'
      Workspace.where(title: name).first
    elsif id
      Workspace.find(id)
    else
      nil
    end.try :title

      select title, from: "Workspace" if title
      attrs.each do |attr_name, attr_value|
        fill_in "update_#{attr_name}", with: attr_value
      end
      
      click_on "Submit update"
    end

    def invite_to! project, email, *labels
      click_on "Invite new users"
      fill_in "Email", with: email
      within("tr#authorizations-#{project.to_param}") do
        check project.title
        Authorization.types.
                      map { |l| l.capitalize.gsub "_", " " }.
                      each_with_index do |current_auth, i|
          all("input[type='checkbox']")[i + 1].set labels.include?(current_auth)
        end
      end

      click_on "Send invitation"
    end

    def add_workspaces! *names
      edit_project!
      page.click_on "Manage workspaces"

      names.each do |name|
        click_on "New workspace"
        within("form") do
          fill_in "Title", with: name
          click_on "Save"
        end
        click_on "Back"
      end

      click_on "Back to project"
    end

    # def set_authorizations_for! user, *labels
    #   user_name = case user.class.to_s
    #   when "User"
    #     user.full_name
    #   when "String"
    #     user
    #   else
    #     raise "unidentified input in #set_authorizations_for!"
    #   end

    #   labels.map! { |l| l.capitalize.gsub "_", " " }

    #   edit_project!
    #   click_on "Authorization settings"

    #   within("tr#authorizations-#{user.to_param}") do
    #     Authorization.types.each_with_index do |auth, i|
    #       if labels[i] == auth
    #         binding.pry
    #       end
    #     end
    #   end
    # end

    def create_project! in_attrs = {}
      page.find("ul#navigation-menu").click_on "My projects"

      click_on "+ Create New Project"

      attrs = Fabricate.attributes_for(:project).merge in_attrs

      fill_in "Project title", with: attrs[:title]
      fill_in "Project value", with: attrs[:value]
      fill_in "Project type", with: attrs[:type]
      fill_in "Project description", with: attrs[:description]
      fill_in "Owner", with: attrs[:owner_title]
      fill_in "Architect", with: attrs[:architect_title]
      fill_in "Builder", with: attrs[:builder_title]
      pick_date "START DATE", attrs[:starts_at]
      pick_date "END DATE", attrs[:ends_at]
      attach_file "project_logo", File.join(Rails.root, "test", "fixtures", "logo.png")
      click_on "Save"
      the_flash_notice_must_be "Project created."
      return Project.last
    end

    def filter_on! workspace_name
      within("ul#workspace-filter-list") do
        click_on workspace_name
      end
    end

    def remove_filter!
      find("ul#workspace-filter-list li.selected a").click
    end
  end
end