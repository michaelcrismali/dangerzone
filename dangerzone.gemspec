Gem::Specification.new do |s|
  s.name        = 'dangerzone'
  s.version     = '1.0.0'
  s.date        = '2013-05-09'
  s.license     = 'MIT'
  s.summary     = 'Takes care of creating accounts, login, logout, forgot password, etc. in Rails'
  s.email       = 'michael.crismali@gmail.com'
  s.homepage    = 'https://github.com/michaelcrismali/dangerzone'
  s.author      = 'Michael Crismali'
  s.description = 'Generates sign-in, sign-out, create account, forgot password, and account confirmation systems for Rails apps. It\'s pretty much Devise for beginners.'

  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.add_dependency('bcrypt-ruby', '~> 3.0')
  s.add_dependency('rails', '~> 3.2')
  s.add_development_dependency('rspec-rails', '~> 2.13')
  s.add_development_dependency('factory_girl_rails', '~> 4.2')
end
