require_relative './lib/version.rb'
Gem::Specification.new do |s|
  s.name        = "inverse_methods"
  s.version     = InverseMethods::VERSION
  s.date        = "2017-01-05"
  s.summary     = "two added methods on Object"
  s.description = ""
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["maxpleaner"]
  s.email       = 'maxpleaner@gmail.com'
  s.required_ruby_version = '~> 2.3'
  s.homepage    = "http://github.com/maxpleaner/inverse_methods"
  s.files       = Dir["lib/**/*.rb", "bin/*", "**/*.md", "LICENSE"]
  s.require_path = 'lib'
  s.required_rubygems_version = ">= 2.5.1"
  s.executables = Dir["bin/*"].map &File.method(:basename)
  s.add_dependency 'debug_inspector'
  s.license     = 'MIT'
end
