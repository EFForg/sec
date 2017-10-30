class UserInvitationsController < Devise::InvitationsController
  protected

  alias_method :after_sign_in_path_for, :admin_root_path
end
