$:.unshift(File.dirname(__FILE__) + '/lib')
require 'ronin/version'

Gem::Specification.new do |s|
  s.name             = 'ronin-wrapper'
  s.version          = Ronin::VERSION
  s.platform         = Gem::Platform::RUBY
  s.date             = '2014-01-05'
  s.summary          = "A framework for masterless configuration management."
  s.description      = "A wrapper to enable masterless configuration management, using Chef and/or Puppet."
  s.authors          = ["Nathan Milford"]
  s.email            = 'nathan@milford.io'
  s.homepage         = 'https://github.com/nmilford/ronin'
  s.add_dependency     "parallel", "~> 0.9.1"
  s.add_dependency     "yajl-ruby", "~> 1.2.0"
  s.add_dependency     "mixlib-log", "~> 1.6.0"
  s.add_dependency     "mixlib-config", "~> 2.1.0"
  s.add_dependency     "mixlib-shellout", "~> 1.3.0"
  s.add_development_dependency 'mime-types', '1.25' if RUBY_VERSION < "1.9"
  s.add_development_dependency "rack", "~> 1.5.2"
  s.add_development_dependency "rake", "~> 10.1.1"
  s.add_development_dependency "tailor", "~> 1.3.0"
  s.add_development_dependency "sinatra", "~> 1.4.4"
  s.add_development_dependency "coveralls", "~> 0.7.0"
  s.add_development_dependency "travis-lint", "~> 1.7.0"
  s.add_development_dependency "rspec-core", "~> 2.14.7"
  s.add_development_dependency "rspec-mocks", "~> 2.14.4"
  s.add_development_dependency "rspec-expectations","~> 2.14.4"
  s.files            = [ "lib/ronin.rb",
                         "lib/ronin/ronin.rb",
                         "lib/ronin/util.rb",
                         "lib/ronin/config.rb",
                         "lib/ronin/cache.rb",
                         "lib/ronin/puppet.rb",
                         "lib/ronin/chef.rb",
                         "lib/ronin/git.rb",
                         "lib/ronin/log.rb",
                         "lib/ronin/etcd.rb",
                         "lib/ronin/artifact_runner.rb",
                         "lib/ronin/run_list.rb",
                         "lib/ronin/version.rb" ]
  s.license          = 'ASF 2.0'
  s.extra_rdoc_files = ["README.md"]
  s.bindir           = "bin"
  s.require_path     = 'lib'
  s.executables      << 'ronin'
end
