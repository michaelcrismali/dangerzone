require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user)}

  it "should have an email address to be valid" do
    user.should be_valid
  end

  describe "update_reset_password_credentials method" do
    before(:each) { user.update_reset_password_credentials }

    it "should have a update_reset_password_credentials method" do
      expect(user).to respond_to(:update_reset_password_credentials)
    end

    it "should update its reset password token" do
      old_token = user.reset_password_token
      user.update_reset_password_credentials
      expect(user.reset_password_token).to_not eq(old_token)
    end

    it "should update its reset password sent at column" do
      old_time = user.reset_password_sent_at
      user.update_reset_password_credentials
      expect(user.reset_password_sent_at).to_not eq(old_time)
    end
  end

  describe "confirm method" do

    before(:each) { user.confirm('ip address') }

    it "should make its confirmed attribute true" do
      user.confirmed.should be_true
    end

    it "should set its ip"

  end


end
