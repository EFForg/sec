class UserInvitationsController < Devise::InvitationsController
  include ActiveAdmin::Devise::Controller

  protected

  alias_method :after_sign_in_path_for, :admin_root_path
end
