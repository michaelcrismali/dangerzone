  post '/sessions' => 'sessions#create', as: 'sessions'
  get '/signin' => 'sessions#new', as: 'sign_in'
  delete '/sign-out' => 'sessions#destroy', as: 'sign_out'

  post '/create_accounts' => 'create_accounts#create', as: 'create_accounts'
  get '/signup' => 'create_accounts#new', as: 'sign_up'
  get '/signup/:id/:reset_password_token' => 'create_accounts#confirm', as: 'confirm'
  get '/check_your_email' => 'create_accounts#check_your_email', as: 'check_your_email'
  put '/resend_confirmation_email' => 'create_accounts#resend_confirmation_email', as: 'resend_confirmation_email'

  get '/forgot_password' => 'reset_passwords#new', as: 'forgot_password'
  put '/reset_password' => 'reset_passwords#send_reset_password', as: 'send_reset_password'
  get '/reset_password/:id/:reset_password_token' => 'reset_passwords#reset_password_form', as: 'reset_password_form'
  put '/update_password' => 'reset_passwords#update_password', as: 'update_password'
