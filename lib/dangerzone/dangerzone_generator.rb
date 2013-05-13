require 'rails/generators'
class DangerzoneGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  include Rails::Generators::Migration
  # desc "add the migrations"

  def self.next_migration_number(path)
    unless @prev_migration_nr
      @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
    else
      @prev_migration_nr += 1
    end
    @prev_migration_nr.to_s
  end

  def generate_the_create_users_migration_file
    migration_template 'migration.rb', 'db/migrate/create_users_table_via_dangerzone.rb'
  end

  def edit_the_routes_file
    routes = IO.read(get_directory + '/templates/routes.rb')
    line = '::Application.routes.draw do'
    gsub_file 'config/routes.rb', /.+(#{Regexp.escape(line)})/mi do |match|
    "#{match}\n\n#{routes}\n"
    end
  end

  def get_rid_of_rails_default_index_page_in_index
    remove_file 'public/index.html'
  end

  def generate_user_model_file
    copy_files_to_app_dir %w(user.rb), 'models'
  end

  def generate_the_nav_partial
    copy_files_to_app_dir %w(_dangerzone_nav.html.erb), 'views/layouts'
  end

  def add_nav_partial_and_notice_to_application_html_erb
    nav = "<%= render 'layouts/dangerzone_nav' %>\n\n<%= notice %>"
    line = '<body>'
    gsub_file 'app/views/layouts/application.html.erb', /(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n#{nav}\n"
    end
  end

  def generate_the_controllers
    file_names = %w(create_accounts_controller.rb reset_passwords_controller.rb sessions_controller.rb)
    copy_files_to_app_dir file_names, 'controllers'
  end

  def add_methods_to_application_controller
    app_controller_methods = IO.read(get_directory + '/templates/controllers/application_controller.rb')
    line = 'protect_from_forgery'
    gsub_file 'app/controllers/application_controller.rb', /.+(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n\n#{app_controller_methods}\n"
    end
  end

  def generate_spec_folder
    empty_directory 'spec'
    empty_directory 'spec/models'
    empty_directory 'spec/factories'
    empty_directory 'spec/controllers'
  end

  def generate_the_specs
    copy_files_to_spec_dir %w(users_factory.rb), 'factories'
    file_names =  %w(create_accounts_controller_spec.rb reset_passwords_controller_spec.rb sessions_controller_spec.rb)
    copy_files_to_spec_dir file_names, 'controllers'
    copy_files_to_spec_dir %w(user_spec.rb), 'models'
    copy_file 'spec/spec_helper.rb', 'spec/spec_helper.rb'
  end

  def generate_mailer
    copy_files_to_app_dir %w(dangerzone_mailer.rb), 'mailers'
  end

  def add_mailer_config_to_development_and_test
    comment = '# Via dangerzone: configures actionmailer to use localhost:3000 as its default url'
    config_stuff = "config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
    line = 'config.assets.debug = true'
    gsub_file 'config/environments/development.rb', /.+(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n\n  #{comment}\n  #{config_stuff}\n\n"
    end
    line = 'config.active_support.deprecation = :stderr'
    gsub_file 'config/environments/test.rb', /.+(#{Regexp.escape(line)})/mi do |match|
      "#{match}\n\n  #{comment}\n  #{config_stuff}\n\n"
    end
  end

  def generate_view_directories
    file_names = %w(create_accounts dangerzone_mailer reset_passwords sessions)
    file_names.each { |f| empty_directory "app/views/#{f}" }
  end

  def fill_view_directories
    file_names = %w(check_your_email.html.erb new.html.erb dangerzone.html.erb)
    copy_files_to_app_dir(file_names, "views/create_accounts")
    file_names = %w(account_confirmation_email.html.erb
                    account_confirmation_email.text.erb
                    reset_password_email.html.erb
                    reset_password_email.text.erb)
    copy_files_to_app_dir(file_names, "views/dangerzone_mailer")
    copy_files_to_app_dir(%w(new.html.erb reset_password_form.html.erb), 'views/reset_passwords')
    copy_files_to_app_dir(%w(new.html.erb), 'views/sessions')
  end

  private

  def gsub_file(relative_destination, regexp, *args, &block)
    content = File.read(relative_destination).gsub(regexp, *args, &block)
    File.open(relative_destination, 'wb') { |file| file.write(content) }
  end

  def get_directory
    directory = __FILE__.split('/')
    directory.pop
    directory.join('/')
  end

  def copy_files_to_app_dir(file_names, gem_path)
    copy_files_to_specific_dir(file_names, gem_path, 'app')
  end

  def copy_files_to_spec_dir(file_names, gem_path)
    file_names.each { |f| copy_file "spec/#{gem_path}/#{f}", "spec/#{gem_path}/#{f}" }
  end

  def copy_files_to_specific_dir(file_names, gem_path, directory)
    file_names.each { |f| copy_file "#{gem_path}/#{f}", "#{directory}/#{gem_path}/#{f}" }
  end
end
