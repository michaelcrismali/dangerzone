# Dangerzone

## About
Dangerzone handles sign-in, sign-out, creating new accounts, confirmation emails, reset password emails,
and user authentification stuff that pretty much every web app needs.

It's pretty much a really stripped down Devise. While Devise is designed for people with a lot of experience,
Dangerzone is more for beginners. All of the files it generates and logic it appends are easy to find and
explore (hopefully, anyway), so if you're new to Rails you can use Dangerzone to learn (also hopefully).

It's also for people who maybe have more experience and don't want to spend time writing all of this stuff
out by hand but don't want to use Devise for whatever reason (ie those with some experience but still
don't understand Devise)

## Dependencies
You'll need these gems (and the gems that they depend on) to use Dangerzone:

* Rails 3.2
* Bcrypt-ruby 3.0
* Thor

## How to install
You can do one of these in your command line (if you have the RubyGems command line stuff installed):

```ruby
gem install dangerzone
```

Alternatively, you can just add this to your app's GemFile:

```ruby
gem 'dangerzone'
```

And then bundle or bundle install.

## How to use

First, add this to your Gemfile:

```ruby
gem 'dangerzone'
```

Then bundle or bundle install.

Then run this command from your app's root directory:

```ruby
rails generate dangerzone
```

You can also put '```g```'' instead of '```generate```' if you're really in a hurry. Anyway, you should see something that
looks like this:

```ruby
      remove  public/index.html
      create  app/views/layouts/_dangerzone_nav.html.erb
      create  app/models/user.rb
      create  app/controllers/create_accounts_controller.rb
      create  app/controllers/reset_passwords_controller.rb
      create  app/controllers/sessions_controller.rb
      create  app/mailers/dangerzone_mailer.rb
      create  app/views/create_accounts
      [etc...]
```

Now, if you're in a fresh app, all you really have to do is ```rake db:migrate```

Note: If you're adding Dangerzone to an existing app then things can be a bit more tricky. For instance,
if you've changed your code in certain places Dangerzone may not edit the files correctly. It may
also overwrite some existing files if they have the same as the files Dangerzone tries to create.
Check out the 'Things to keep in mind' section below for more information.

Once you've added some pages you only want registered users to see (ie a my account page), all you have to do
is add this to the controllers that you only want registered/authorized users to see:

```ruby
before_filter :authorize_user
```

That's it. Well if you only want specific actions on a given controller to be for registered users only, just use:

```ruby
before_filter :authorize_user, :only => [ :different, :controller, :actions ]
```

or

```ruby
before_filter :authorize_user, :except => [ :various, :controller, :actions ]
```

Now that's it.

## Things to keep in mind

* Dangerzone generates a migration file that creates a users table, so if you already have a users table
or call your users something else, then you'll have to write your own migration that adds the appropriate
columns and default values to your model.
* If you already have a user.rb file in your models it may be overwritten. Check the list below for all of the
files Dangerzone generates and my overwrite.
* Dangerzone edits certain files (for instance, it uncomments bcrypt in your GemFile), so if you've changed
some code in those files in a certain way, Dagerzone may not edit them properly. Consult the list below
for all of the files it edits and how it edits them.
* Dangerzone sets a root\_url that you'll probably want to change.
* Dangerzone uses action mailer and sets action mailer's default to 'localhost:3000' in your development.rb file.
So if you want to use a different mailer or use Dangerzone in test or production environments, you'll have to figure
out how to configure it for those situations yourself.
* Dangerzone gives you a current\_user method that you can call in any of your controllers. It returns @current\_user
in addition to setting the @current\_user instance variable. The instance variable will already be set for any action
has authorize\_user run in the before filter.
* Dangerzone deletes index.html from your app's public folder.
* The pages and emails that Dangerzone generates for you are pretty bare bones, so you'll probably want to style them
* If you actually use Dangerzone code in production, remember that the email address validation is basic so
every once in a while you should probably destroy all of the accounts that are reasonably old and are unconfirmed.
Or set up an automated task that does that.

### Files Dangerzone Edits
* app/controllers/application\_controller.rb - adds authorize\_user and current\_user methods (so every controller
can add them to before\_filters)
* app/view/layouts/application.html.erb - adds render
* config/environments/development.rb - sets action mailer's default url to localhost:3000
* config/routes.rb - adds routes and sets root\_url
* GemFile - uncomments bcrypt

### Directories Dangerzone Creates
* app/mailers/dangerzone\_mailer.rb
* app/views/create\_accounts
* app/views/dangerzone\_mailer
* app/views/reset\_passwords
* app/views/sessions

### Files Dangerzone Creates
* app/views/layouts/\_dangerzone_nav.html.erb
* app/models/user.rb
* app/controllers/create\_accounts\_controller.rb
* app/controllers/reset\_passwords\_controller.rb
* app/controllers/sessions\_controller.rb
* app/views/create\_accounts/check\_your\_email.html.erb
* app/views/create\_accounts/new.html.erb
* app/views/create\_accounts/dangerzone.html.erb
* app/views/dangerzone\_mailer/account\_confirmation\_email.html.erb
* app/views/dangerzone\_mailer/account\_confirmation\_email.text.erb
* app/views/dangerzone\_mailer/reset\_password\_email.html.erb
* app/views/dangerzone\_mailer/reset\_password\_email.text.erb
* app/views/layouts/\_dangerzone\_nav.html.erb
* app/views/reset\_passwords/new.html.erb
* app/views/reset\_passwords/reset\_password\_form.html.erb
* app/views/sessions/new.html.erb
* db/migrate/[some timestamp]\_create\_users\_table\_via\_dangerzone.rb
