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

  describe 'password and password_confirmation' do
    let(:user2) { FactoryGirl.build(:user) }

    it 'saves when they are present and match' do
      expect(user2.save).to be_true
    end

    it 'saves when they are not present but the user has already been persisted' do
      user3 = User.find(user.id)
      expect(user3.password).to be_nil
      expect(user3.password_confirmation).to be_nil
      expect(user3.save).to be_true
    end

    it 'does not save when they are not present' do
      user2.password = ''
      user2.password_confirmation = ''
      expect(user2.save).to be_false
    end

    it 'does not save when they do not match' do
      user2.password = 'something'
      expect(user2.save).to be_false
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

  describe '#in_time?' do

    before { user.update_reset_password_credentials }

    it 'returns true if reset password sent at was less than 24 hours ago' do
      expect(user).to be_in_time
    end

    it 'returns false if reset password sent at was more than 24 hours ago' do
      user.stub(:reset_password_sent_at).and_return(Time.now - 5.weeks)
      expect(user).to_not be_in_time
    end

  end

  describe '#token_matches?' do

    before { user.update_reset_password_credentials }

    it 'returns true if its argument matches its reset password token' do
      valid_token = user.reset_password_token
      expect(user.token_matches?(valid_token)).to be_true
    end

    it 'returns false if its argument does not match its reset password token' do
      invalid_token = 'something that does not match'
      expect(user.token_matches?(invalid_token)).to be_false
    end
  end
end
