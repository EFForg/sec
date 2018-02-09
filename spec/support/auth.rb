
module Auth
  def login(user)
    login_as(user, scope: :admin_user)
  end
end
