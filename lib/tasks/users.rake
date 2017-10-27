
namespace :users do
  desc "Create a new admin user"
  task create_admin: :environment do
    require "io/console"

    print "Email: "
    email = STDIN.gets || exit(1)

    print "Password: "
    password = STDIN.noecho(&:gets) || exit(1)
    puts

    print "Password (again): "
    password_confirmation = STDIN.noecho(&:gets) || exit(1)
    puts

    [email, password, password_confirmation].each(&:chomp!)

    user = AdminUser.create!(
      email: email,
      password: password,
      password_confirmation: password_confirmation
    )
  end
end
