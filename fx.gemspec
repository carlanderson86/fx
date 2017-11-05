$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fx"
  s.version     = Fx::VERSION
  s.authors     = ["Carl Anderson"]
  s.email       = ["carl@8bitanderson.com"]
  s.homepage    = "http://www.8bitanderson.com"
  s.summary     = "FX - Library to help with currency conversion"
  s.description = "FX - Library to help with currency conversion, can be extended"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency 'rufus-scheduler', '~> 3.4'
  s.add_dependency 'nokogiri'
end
