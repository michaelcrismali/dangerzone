require 'spec_helper'

describe ResetPasswordsController do

  describe '#requested_reset_password' do
    before { ActionMailer::Base.deliveries = []}
    let(:user) { FactoryGirl.create(:user) }

    it "renders to forgot_password page (:new)" do
      put :requested_reset_password, email: user.email
      expect(response).to render_template :new
    end

    context 'when update_reset_password_credentials is successful' do

      it "sends an email" do
        put :requested_reset_password, email: user.email
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "updates the user's reset password credentials" do
        old_token = user.reset_password_token
        old_time = user.reset_password_sent_at
        put :requested_reset_password, email: user.email
        expect(User.first.reset_password_token).to_not eq(old_token)
        expect(User.first.reset_password_sent_at).to_not eq(old_time)
      end
    end

    context 'when update_reset_password_credentials fails' do
      it "doesn't send an email" do
        put :requested_reset_password, email: "not an email"
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe '#reset_password_form' do
    let(:user){ FactoryGirl.create(:user) }
    before { user.update_reset_password_credentials }

    context "user has proper reset password credentials" do
      before {get :reset_password_form, id: user.id, reset_password_token: user.reset_password_token}

      it "renders reset password form" do
        expect(response).to render_template :reset_password_form
      end

      it "puts the user's id in the session hash" do
        expect(session[:reset_password_user_id]).to eq(user.id)
      end
    end

    context "user does not have right token" do
      before { get :reset_password_form, id: user.id, reset_password_token: 'wrong'}

      it "renders the forgot password page" do
        expect(response).to render_template :new
      end

      it "does not set the session hash to the user's id" do
        expect(session[:reset_password_user_id]).to be_nil
      end
    end

    context "user is trying to reset password after more than an hour" do
      before do
        user.reset_password_sent_at = Time.now - 2.days
        user.save
        get :reset_password_form, id: user.id, reset_password_token: user.reset_password_token
      end

      it "renders the forgot password page" do
        expect(response).to render_template :new
      end

      it "does not set the session hash to the user's id" do
        expect(session[:reset_password_user_id]).to be_nil
      end
    end
  end

  describe '#update_password' do
    let(:user){ FactoryGirl.create(:user) }
    before do
      user.update_reset_password_credentials
      session[:reset_password_user_id] = user.id
    end

    context 'the user is in time' do

      context 'and their password and confirmation match' do
        before { put :update_password, password: 'new_password', password_confirmation: 'new_password' }

        it "clears session at :reset_password_user_id" do
          expect(session[:reset_password_user_id]).to be_nil
        end

        it "sets session at :user_id to their user id" do
          expect(session[:user_id]).to eq(user.id)
        end

        it "redirects them to the root_url" do
          expect(response).to redirect_to root_url
        end
      end

      context "and their password and confirmation don't match" do
        it "redirects them to the reset password form" do
          put :update_password, password: 'new_password', password_confirmation: "doesn't match"
          expect(response).to redirect_to reset_password_form_url(user.id, user.reset_password_token)
        end
      end

    end

    context "user is too late" do
      it "redirects to #requested_reset_password" do
        user.reset_password_sent_at = Time.now - 2.days
        user.save
        put :update_password, password: 'new_password', password_confirmation: 'new_password'
        expect(response).to redirect_to :requested_reset_password
      end
    end

    context "user lacks the proper session credentials" do
      it "redirects to #requested_reset_password" do
        session[:reset_password_user_id] = nil
        put :update_password, password: 'new_password', password_confirmation: 'new_password'
        expect(response).to redirect_to :requested_reset_password
      end
    end
  end

  describe '#new' do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end
end
