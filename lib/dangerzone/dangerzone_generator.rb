class DangerzoneGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def edit_the_routes_file
    gsub_file('config/routes.rb')
    line = "::Application.routes.draw do"
    gsub_file 'config/routes.rb', /(#{Regexp.escape(line)})/mi do |match|
    " #{match}\n  has_many :tags\n"
    end
  end

  def generate_the_models_migration_file

  end

  def generate_the_nav_partial

  end

  def add_nav_partial_to_layouts_folder

  end

  def generate_user_model_file

  end

  def generate_the_controller

  end

  def add_methods_to_application_controller

  end

  def generate_mailer

  end

  def generate_view_directories
    empty_directory "app/views/dangerzone"
    empty_directory "app/views/dangerzone_mailer"
  end

  def fill_view_directories
    copy_file "signin.html.erb", "app/views/create_accounts/signin.html.erb"
  end

  private

  def gsub_file(relative_destination, regexp, *args, &block)
    path = destination_path(relative_destination)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') { |file| file.write(content) }
  end

end
