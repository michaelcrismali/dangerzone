Gem::Specification.new do |s|
  s.name        = "dangerzone"
  s.version     = '0.0.0'
  s.date        = '2013-03-30'
  s.license     = "MIT"
  s.summary     = "Takes care of creating accounts, login, logout, forgot password, etc. in Rails"
  s.email       = "michael.crismali@gmail.com"
  s.homepage    = "https://github.com/michaelcrismali/dangerzone"
  s.authors     = ['Michael Crismali']

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("bcrypt-ruby", "~> 3.0")
  s.add_dependency("rails", "~> 3.2")
  s.add_dependency("thor")
end
