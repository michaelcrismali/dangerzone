Dummy::Application.routes.draw do

  root to: 'create_accounts#dangerzone'

  get '/dangerzone' => 'create_accounts#dangerzone', as: 'dangerzone'

  post '/sessions' => 'sessions#create', as: 'sessions'
  get '/sign-in' => 'sessions#new', as: 'sign_in'
  delete '/sign-out' => 'sessions#destroy', as: 'sign_out'

  post '/create_accounts' => 'create_accounts#create', as: 'create_accounts'
  get '/sign-up' => 'create_accounts#new', as: 'sign_up'
  get '/sign-up/:id/:reset_password_token' => 'create_accounts#confirm', as: 'confirm'
  get '/check_your_email' => 'create_accounts#check_your_email', as: 'check_your_email'
  put '/resend_confirmation_email' => 'create_accounts#resend_confirmation_email', as: 'resend_confirmation_email'

  get '/forgot_password' => 'reset_passwords#new', as: 'forgot_password'
  put '/reset_password' => 'reset_passwords#send_reset_password', as: 'send_reset_password'
  get '/reset_password/:id/:reset_password_token' => 'reset_passwords#reset_password_form', as: 'reset_password_form'
  put '/update_password' => 'reset_passwords#update_password', as: 'update_password'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
