require 'spec_helper'

describe SessionsController do

  describe '#new' do
    it "renders the 'new' page" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe '#destroy' do

    it "clears the permanent cookies" do
      cookies.permanent[:remember_token] = 'remember token'
      delete :destroy
      expect(cookies[:remember_token]).to be_nil
    end

    it "clears the session hash" do
      session[:user_id] = 5
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the sign in page" do
      delete :destroy
      expect(response).to redirect_to :sign_in
    end
  end

  describe '#create' do
    let(:user){ FactoryGirl.create(:user, :confirmed) }
    let(:params){ {email: user.email, password: 'password1234', remember_me: '0'} }
    before do
      session[:user_id] = nil
      cookies.delete(:remember_token)
    end

    context "non user email tries to login" do
      it "redirects to the sign in page" do
        post :create
        expect(response).to redirect_to :sign_in
      end
    end

    context "bad password" do
      it "redirects to the sign in page" do
        params[:password] = 'wrong'
        post :create, params
        expect(response).to redirect_to :sign_in
      end
    end

    context "user is not confirmed" do
      it "redirects to the sign in page" do
        unconfirmed_user = FactoryGirl.create(:user, email: 'email@example.com')
        params[:email] = unconfirmed_user.email
        post :create, params
        expect(response).to redirect_to :sign_in
      end
    end

    context "password is correct and user is confirmed" do

      it "updates the user's sign in ip" do
        user.sign_in_ip =  'old ip'
        user.save
        post :create, params
        expect(assigns(:user)).to_not eq('old ip')
      end

      it "increments the user's sign in count" do
        old_sign_in_count = user.sign_in_count
        post :create, params
        expect(assigns(:user).sign_in_count).to_not eq(old_sign_in_count)
      end

      it "redirects to the root url" do
        post :create, params
        expect(response).to redirect_to :root
      end

      it "saves the user" do
        old_updated_at = user.updated_at
        post :create, params
        expect(assigns(:user)).to_not eq(old_updated_at)
      end

      context "user has selected remember me" do
        before { params[:remember_me] = '1' }

        it "gives the user a new remember token" do
          old_token = user.remember_token
          post :create, params
          expect(assigns(:user)).to_not eq(old_token)
        end

        it "puts the user's id in the permanent cookies" do
          post :create, params
          expect(cookies[:remember_token]).to_not be_nil
        end
      end

      context "user has not selected remember me" do
        it "puts the user's id in the session hash" do
          post :create, params
          expect(session[:user_id]).to eq(user.id)
        end
      end
    end
  end
end
