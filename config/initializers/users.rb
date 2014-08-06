DependentLoader.start(:users) do |on|

  on.success do
    Admin.create(username: "adminuser", full_name: "Admin User",
      email: "adminuser@example.com", password: "password", password_confirmation: "password")
  end

end