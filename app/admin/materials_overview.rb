ActiveAdmin.register_page "Materials Overview" do
  menu parent: "Pages"

  page_action :update, method: :patch do
    @page = Page.find_by!(name: "materials-overview")

    if @page.update(params[:page].permit(:body))
      flash[:success] = "Content has been successfully updated."
      redirect_to admin_materials_overview_path
    else
      messages = @page.errors.full_messages.join
      flash[:error] = "Error: " + messages
      redirect_to admin_materials_overview_path
    end
  end

  content do
    semantic_form_for(Page.find_by(name: "materials-overview"),
                      url: admin_materials_overview_update_path) do |f|
      f.inputs{ f.input :body, as: :ckeditor, label: "Intro" } +

      f.actions{ f.submit "Update Content" }
    end
  end
end
