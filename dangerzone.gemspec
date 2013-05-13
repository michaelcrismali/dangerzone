Gem::Specification.new do |s|
  s.name        = 'dangerzone'
  s.version     = '0.5.1'
  s.date        = '2013-05-13'
  s.license     = 'MIT'
  s.summary     = 'Takes care of creating accounts, login, logout, forgot password, etc. in Rails apps'
  s.email       = 'michael.crismali@gmail.com'
  s.homepage    = 'https://github.com/michaelcrismali/dangerzone'
  s.author      = 'Michael Crismali'
  s.description = 'Generates sign-in, sign-out, create account, forgot password, and account confirmation systems (via email) for Rails apps. It\'ll get your prototype up and running fast. It\'s pretty much Devise for beginners.'

  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.post_install_message = "Welcome to the... Dangerzooooone!"

  s.add_dependency('bcrypt-ruby', '~> 3.0')
  s.add_dependency('rails', '~> 3.2')
  s.add_development_dependency('rspec-rails', '~> 2.13')
  s.add_development_dependency('factory_girl_rails', '~> 4.2')
end
