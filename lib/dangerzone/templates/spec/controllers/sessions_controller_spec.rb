require 'spec_helper'

describe SessionsController do

  describe '#new' do
    let(:confirmed_user) { FactoryGirl.create(:user) }

    it 'renders the :new page' do
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to root if user is already signed in' do
      session[:user_id] = 5
      get :new
      expect(response).to redirect_to :root
    end
  end

  describe '#destroy' do

    it 'clears the permanent cookies' do
      cookies.permanent[:remember_token] = 'remember token'
      delete :destroy
      expect(cookies[:remember_token]).to be_nil
    end

    it 'clears the session hash' do
      session[:user_id] = 5
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the sign in page' do
      delete :destroy
      expect(response).to redirect_to :sign_in
    end
  end

  describe '#create' do
    let(:user){ FactoryGirl.create(:user, :confirmed) }
    let(:params){ {email: user.email, password: 'password1234'} }

    before { controller.reset_session }

    it 'clears cookies before signing in so 2 people cannot be signed in at once (w/out remember me)' do
      session[:user_id] = 'x'
      cookies.permanent[:remember_token] = 'some token'
      post :create, params
      expect(session[:user_id]).to eq(user.id)
      expect(cookies[:remember_token]).to be_nil
    end

    it 'clears cookies before signing in so 2 people cannot be signed in at once (with remember me)' do
      session[:user_id] = 'x'
      cookies.permanent[:remember_token] = 'some token'
      params[:remember_me] = '1'
      post :create, params
      expect(session[:user_id]).to be_nil
      expect(cookies[:remember_token]).to eq(assigns(:user).remember_token)
    end

    context 'when a non user email tries to login' do
      it 'redirects to the sign in page' do
        post :create
        expect(response).to redirect_to :sign_in
      end
    end

    context 'incorrect password' do
      it 'redirects to the sign in page' do
        params[:password] = 'wrong'
        post :create, params
        expect(response).to redirect_to :sign_in
      end
    end

    context 'user is not confirmed' do
      it 'redirects to the sign in page' do
        params[:email] = FactoryGirl.create(:user).email
        post :create, params
        expect(response).to redirect_to :sign_in
      end
    end

    context 'password is correct and user is confirmed' do

      it 'updates the their sign in ip' do
        user.sign_in_ip = 'old ip'
        user.save
        post :create, params
        expect(assigns(:user)).to_not eq('old ip')
      end

      it 'increments the their sign in count' do
        old_sign_in_count = user.sign_in_count
        post :create, params
        expect(assigns(:user).sign_in_count).to eq(old_sign_in_count + 1)
      end

      it 'redirects to the root url' do
        post :create, params
        expect(response).to redirect_to :root
      end

      it 'saves the user' do
        old_updated_at = user.updated_at
        post :create, params
        expect(assigns(:user)).to_not eq(old_updated_at)
      end

      context 'user has selected remember me' do
        before { params[:remember_me] = '1' }

        it 'gives the user a new remember token' do
          old_token = user.remember_token
          post :create, params
          expect(assigns(:user)).to_not eq(old_token)
        end

        it 'puts the their id in the permanent cookies' do
          post :create, params
          expect(cookies[:remember_token]).to_not be_nil
        end
      end

      context 'user has not selected remember me' do
        it 'puts the their id in the session hash' do
          post :create, params
          expect(session[:user_id]).to eq(user.id)
        end
      end
    end
  end
end
