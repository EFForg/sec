ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end

  collection_action :new_invitation do
    @user = AdminUser.new
  end

  collection_action :invitations, method: :post do
    @user = AdminUser.invite!(params[:admin_user].permit(:email),
                              current_admin_user)

    if @user.errors.empty?
      flash[:success] = "User has been successfully invited."
      redirect_to admin_admin_users_path
    else
      messages = @user.errors.full_messages.map { |msg| msg }.join
      flash[:error] = "Error: " + messages
      redirect_to new_invitation_admin_admin_users_path
    end
  end

  action_item :invite_user, only: :index do
    link_to "Invite User", new_invitation_admin_admin_users_path
  end
end
