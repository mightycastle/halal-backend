require 'spec_helper'
require "rails_helper"

describe User do
  context "User model" do
    it "check field user" do
      first_name = 'first_name'
      last_name = 'last_name'
      user = create(:user, first_name: first_name, last_name: last_name)
      expect(User.last.first_name).to eq(first_name)
      expect(User.last.last_name).to eq(last_name)
    end

    it "should uniqueness username" do
      user = create(:user, username: 'username')
      FactoryGirl.build(:user, :username => 'username').should_not be_valid
    end

    it "should invalid create user with empty username" do
      FactoryGirl.build(:user, :username => '').should_not be_valid
    end

    it "should invalid create user with exist email" do
      email = 'email_example@gmail.com'
      user = create(:user,email: email )
      FactoryGirl.build(:user, :email => email).should_not be_valid
    end

    it { User.reflect_on_association(:restaurants).macro.should   eq(:has_many) }
    it { User.reflect_on_association(:photos).macro.should   eq(:has_many) }
    it { User.reflect_on_association(:reviews).macro.should   eq(:has_many) }
    it { User.reflect_on_association(:admin_photos).macro.should   eq(:has_many) }
    it { User.reflect_on_association(:subscriptions).macro.should   eq(:has_many) }

    it { (create(:user).is_verified?).should eq true} 
    it { (create(:user).is_admin_role?).should eq false} 
    it { (create(:user).is_profession_user?).should eq false} 
  end
end

