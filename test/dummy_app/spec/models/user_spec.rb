require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user)}

  describe "users' email" do
    it "is always present" do
      user.stub(email: nil)
      expect(user).to_not be_valid
    end

    it "is unique" do
      user.save
      user2 = FactoryGirl.build(:user, email: user.email)
      expect(user2).to_not be_valid
    end

    it "follows a basic format" do
      user.stub(email: '@')
      expect(user).to_not be_valid
      user.stub(email: 'x@x.x')
      expect(user).to be_valid
    end

    it "is always lowercase" do
      user.stub(email: 'X@x.x')
      user.save
      user.unstub(:email)
      expect(user.email).to eq('x@x.x'.downcase)
    end
  end

  describe "users' update reset password credentials method" do

    it "haves a update_reset_password_credentials method" do
      expect(user).to respond_to(:update_reset_password_credentials)
    end

    it "changes the reset password token" do
      old_token = user.reset_password_token
      user.update_reset_password_credentials
      expect(user.reset_password_token).to_not eq(old_token)
    end

    it "changes the reset password sent at time" do
      old_time = user.reset_password_sent_at
      user.update_reset_password_credentials
      expect(user.reset_password_sent_at).to_not eq(old_time)
    end

    it "saves the user" do
      user.should_receive(:save)
      user.update_reset_password_credentials
    end

  end

  describe "users's confirm method" do

    it "saves the user" do
      user.should_receive(:save)
      user.confirm('ip address')
    end

    it "sets the ip address to the argument" do
      thing = 'thing'
      user.sign_in_ip = 'something else'
      user.confirm(thing)
      expect(user.sign_in_ip).to eq(thing)
    end

    it "makes their confirmed attribute 'true'" do
      user.confirm('ip')
      expect(user.confirmed).to be_true
    end

    it "sets reset_password_sent_at to nil" do
      user.reset_password_sent_at = Time.now
      user.confirm('ip')
      expect(user.reset_password_sent_at).to be_nil
    end

    it "sets reset_password_token to nil" do
      user.reset_password_token = 'something'
      user.confirm('ip')
      expect(user.reset_password_token).to be_nil
    end
  end



end
