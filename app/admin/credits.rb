ActiveAdmin.register_page "Credits" do
  menu parent: "Pages", priority: 10000

  page_action :update, method: :patch do
    @credits = Page.find_by!(name: "credits")

    if @credits.update(params[:page].permit(:body))
      flash[:success] = "Credits have been successfully updated."
      redirect_to admin_credits_path
    else
      messages = @credits.errors.full_messages.join
      flash[:error] = "Error: " + messages
      redirect_to admin_credits_path
    end
  end

  content do
    semantic_form_for(Page.find_by(name: "credits"),
                      url: admin_credits_update_path) do |f|
      f.inputs{ f.input :body, as: :ckeditor } +

      f.actions{ f.submit "Update Credits" }
    end
  end
end
