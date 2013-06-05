module AuthenticationHelpers
  
  def create_current_user(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= create(:user)
  end
  
  def create_user(username, admin = false)
    create(:user, username: username, admin: admin)
  end
  
  def opponent
    @opponent ||= create_user("WorthyOpponent")
  end
  
  def other_member
    @other_member ||= create_user("OtherMember")
  end
  
  def sign_in(user)
    visit sign_in_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "sign in"
  end
end

World(AuthenticationHelpers)