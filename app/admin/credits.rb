ActiveAdmin.register_page "Credits" do
  menu parent: "Pages", priority: 10000

  page_action :update, method: :patch do
    @credits = ManagedContent.find_by!(region: "credits")

    if @credits.update(params[:managed_content].permit(:body))
      flash[:success] = "Credits have been successfully updated."
      redirect_to admin_credits_path
    else
      messages = @credits.errors.full_messages.join
      flash[:error] = "Error: " + messages
      redirect_to admin_credits_path
    end
  end

  content do
    semantic_form_for(ManagedContent.find_by(region: "credits"),
                      url: admin_credits_update_path) do |f|
      f.inputs{ f.input :body, as: :ckeditor } +

      f.actions{ f.submit "Update Credits" }
    end
  end
end
