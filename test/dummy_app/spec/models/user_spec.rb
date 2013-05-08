require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user)}

  describe '#email' do
    it 'must be present to save user' do
      user.email = nil
      expect(user).to_not be_valid
      user.email = ''
      expect(user).to_not be_valid
    end

    it 'is unique' do
      user2 = FactoryGirl.build(:user, email: user.email)
      expect(user2).to_not be_valid
    end

    it 'follows a basic format' do
      user.email = '@'
      expect(user).to_not be_valid
      user.email = 'invalid'
      expect(user).to_not be_valid
      user.email = 'x@x.x'
      expect(user).to be_valid
    end

    it 'is always lowercase' do
      user.email = 'X@x.x'
      user.save
      expect(user.email).to eq('x@x.x'.downcase)
    end
  end

  describe '#password and #password_confirmation' do
    let(:unsaved_user) { FactoryGirl.build(:user) }

    it 'saves when they are present and match' do
      expect(unsaved_user.save).to be_true
    end

    it 'saves when they are not present but the user has already been persisted' do
      reloaded_user = User.find(user.id) # the reload method doesn't work for this test
      expect(reloaded_user.password).to be_nil
      expect(reloaded_user.password_confirmation).to be_nil
      expect(reloaded_user.save).to be_true
    end

    it 'do not save when they are absent' do
      unsaved_user.password = ''
      unsaved_user.password_confirmation = ''
      expect(unsaved_user.save).to be_false
    end

    it 'do not save when they do not match' do
      unsaved_user.password = 'something'
      expect(unsaved_user.save).to be_false
    end
  end

  describe '#update_reset_password_credentials' do

    it 'can be called on a user instance' do
      expect(user).to respond_to(:update_reset_password_credentials)
    end

    it 'changes the reset password token' do
      old_token = user.reset_password_token
      user.update_reset_password_credentials
      expect(user.reset_password_token).to_not eq(old_token)
    end

    it 'changes the reset password sent at time' do
      old_time = user.reset_password_sent_at
      user.update_reset_password_credentials
      expect(user.reset_password_sent_at).to_not eq(old_time)
    end

    it 'saves the user' do
      user.should_receive(:save)
      user.update_reset_password_credentials
    end
  end

  describe '#confirm!' do

    it 'saves the user' do
      user.should_receive(:save)
      user.confirm!('ip address')
    end

    it 'sets the ip address to the argument' do
      user.sign_in_ip = 'something else'
      user.confirm!('thing')
      expect(user.sign_in_ip).to eq('thing')
    end

    it "makes their confirmed attribute 'true'" do
      user.confirm!('ip')
      expect(user.confirmed).to be_true
    end

    it 'sets reset_password_sent_at to nil' do
      user.reset_password_sent_at = Time.now
      user.confirm!('ip')
      expect(user.reset_password_sent_at).to be_nil
    end

    it 'sets reset_password_token to nil' do
      user.reset_password_token = 'token'
      user.confirm!('ip')
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
      expect(user.token_matches?(user.reset_password_token)).to be_true
    end

    it 'returns false if its argument does not match its reset password token' do
      expect(user.token_matches?('invalid_token')).to be_false
    end
  end

  describe '#sign_in!' do
    let(:confirmed_user) { FactoryGirl.create(:user, :confirmed) }
    let(:password) { confirmed_user.password }

    it 'returns false if the user is not confirmed' do
      expect(user.sign_in!('ip', user.password)).to be_false
    end

    it 'returns false if the password is wrong' do
      expect(user.sign_in!('ip', 'wrong pw')).to be_false
    end

    it 'updates their sign_in_ip' do
      old_ip = confirmed_user.sign_in_ip
      confirmed_user.sign_in!('new ip', password)
      expect(confirmed_user.sign_in_ip).to eq('new ip')
    end

    it 'increments their sign_in_count' do
      old_count = confirmed_user.sign_in_count
      confirmed_user.sign_in!('ip', password)
      expect(confirmed_user.sign_in_count).to eq(old_count + 1)
    end

    it 'gives them a new remember_token' do
      old_token = confirmed_user.remember_token
      confirmed_user.sign_in!('ip', password)
      expect(confirmed_user.sign_in_count).to_not eq(old_token)
    end

    it 'saves the user' do
      confirmed_user.should_receive(:save)
      confirmed_user.sign_in!('ip', password)
    end
  end
end
