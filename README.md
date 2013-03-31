Dangerzone

the before filter belongs in any controller your users
need to be logged in to access

before_filter :authorize_user

You can use this code below in any controller in case you only want users
to have to sign in for certain things

before_filter :authorize_user, :only => [ :different, :controller, :actions ]
before_filter :authorize_user, :except => [ :different, :controller, :actions ]
