require 'spec_helper'

describe User, focus: true do

  it "should not be able to register new users" do
    User.devise_modules.should_not include(:registerable)
  end

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }


  it { should have_many(:bookings)}
  it { should have_many(:permissions)}
  it { should have_many(:allowed_actions).through(:permissions)}

  it {should have_db_column(:admin).of_type(:boolean).with_options(default: false)}
  it {should have_db_column(:mail_me).of_type(:boolean).with_options(default: true)}

  describe '#without_user' do
    let!(:users) {create_list(:user, 3)}
    subject { User.without_user(users.first) }

    it {should_not include(users.first)}
    it {should have(2).items}

  end

  describe "search" do

    let!(:user1) {create(:user, full_name: "lucy lucy")}
    let!(:user2) {create(:user, full_name: "lucille")}
    let!(:user3) {create(:user, full_name: "henrietta")}

    describe '#by_term' do

      it {expect(User.by_term("lu")).to have(2).items}
      it {expect(User.by_term("h")).to have(1).item}
      it {expect(User.by_term("dx")).to be_empty}
    end

    describe '#names_from_term_except_user' do

      let!(:user4) { create(:user, full_name: "lucifer")}

      it { expect(User.names_from_term_except_user(user4, "lu")).to have(2).items}
      it { expect(User.names_from_term_except_user(user4, "lu")).to_not include("lucifer")}


    end

  end



  describe "duplicated email" do

    let!(:user) {create(:user, email: "joebloggs@example.com")}

    it { expect(build(:user, email: "joebloggs@example.com")).to be_valid }
  end

end