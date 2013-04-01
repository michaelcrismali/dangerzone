require 'rails/generators'
class DangerzoneGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def edit_the_routes_file
    routes = IO.read(get_directory + '/templates/routes.rb')
    line = "::Application.routes.draw do"
    gsub_file 'config/routes.rb', /.+(#{Regexp.escape(line)})/mi do |match|
    "#{match}\n\n#{routes}\n"
    end
  end

  def generate_the_nav_partial
    copy_file "views/nav.html.erb", "app/views/layouts/_dangerzone_nav.html.erb"
  end

  def add_nav_partial_to_application_html_erb
    nav = "<%= render 'layouts/dangerzone_nav' %>"
    line = "<body>"
    gsub_file 'app/views/layouts/application.html.erb', /(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n#{nav}\n"
    end
  end

  def generate_user_model_file
    copy_file "models/user.rb", "app/models/user.rb"
  end

  def generate_the_controllers
    copy_file "controllers/create_accounts_controller.rb", "app/controllers/create_accounts_controller.rb"
    copy_file "controllers/reset_passwords_controller.rb", "app/controllers/reset_passwords_controller.rb"
    copy_file "controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
  end

  def add_methods_to_application_controller
    app_controller_methods = IO.read(get_directory + '/templates/controllers/application_controller.rb')
    line = "protect_from_forgery"
    gsub_file 'app/controllers/application_controller.rb', /.+(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n\n#{app_controller_methods}\n"
    end
  end

  def generate_mailer
    copy_file "mailers/dangerzone_mailer.rb", "app/mailers/dangerzone_mailer.rb"
  end

  def add_mailer_config_to_development
    comment = "# Via dangerzone: configures actionmailer to use localhost:3000 as its default url"
    config_stuff = "config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
    line = "config.assets.debug = true"
    gsub_file 'config/environments/development.rb', /.+(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n\n  #{comment}\n  #{config_stuff}\n\n"
    end
  end

  def generate_view_directories
    empty_directory "app/views/create_accounts"
    empty_directory "app/views/dangerzone_mailer"
    empty_directory "app/views/reset_passwords"
    empty_directory "app/views/sessions"
  end

  def fill_view_directories
    copy_file "views/create_accounts/check_your_email.html.erb", "app/views/create_accounts/check_your_email.html.erb"
    copy_file "views/create_accounts/new.html.erb", "app/views/create_accounts/new.html.erb"

    copy_file "views/dangerzone_mailer/account_confirmation_email.html.erb", "app/views/dangerzone_mailer/account_confirmation_email.html.erb"
    copy_file "views/dangerzone_mailer/account_confirmation_email.text.erb", "app/views/dangerzone_mailer/account_confirmation_email.text.erb"
    copy_file "views/dangerzone_mailer/reset_password_email.html.erb", "app/views/dangerzone_mailer/reset_password_email.html.erb"
    copy_file "views/dangerzone_mailer/reset_password_email.text.erb", "app/views/dangerzone_mailer/reset_password_email.text.erb"

    copy_file "views/reset_passwords/_form.html.erb", "app/views/reset_passwords/_form.html.erb"
    copy_file "views/reset_passwords/new.html.erb", "app/views/reset_passwords/new.html.erb"
    copy_file "views/reset_passwords/reset_password_form.html.erb", "app/views/reset_passwords/reset_password_form.html.erb"
    copy_file "views/reset_passwords/send_reset_password.html.erb", "app/views/reset_passwords/send_reset_password.html.erb"

    copy_file "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
  end

  include Rails::Generators::Migration
  desc "add the migrations"

  def self.next_migration_number(path)
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end

  def generate_the_users_migration_file
    migration_template "migration.rb", "db/migrate/create_users_table_via_dangerzone.rb"
  end

  private

  def gsub_file(relative_destination, regexp, *args, &block)
    path = relative_destination
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') { |file| file.write(content) }
  end

  def get_directory
    directory = __FILE__.split('/')
    directory.pop
    directory.join('/')
  end

end
