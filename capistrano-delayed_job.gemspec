# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: capistrano-delayed_job 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-delayed_job"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Leif Ringstad"]
  s.date = "2015-03-26"
  s.description = "Capistrano recipes for Delayed Job using runit and monit."
  s.email = "leifcr@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "capistrano-delayed_job.gemspec",
    "lib/capistrano/delayed_job.rb",
    "lib/capistrano/helpers/delayed_job/monit.rb",
    "lib/capistrano/helpers/delayed_job/runit.rb",
    "lib/capistrano/helpers/delayed_job/template_paths.rb",
    "lib/capistrano/tasks/config.rake",
    "lib/capistrano/tasks/monit.rake",
    "lib/capistrano/tasks/runit.rake",
    "templates/monit/delayed_job.conf.erb",
    "templates/runit/finish.erb",
    "templates/runit/log/run.erb",
    "templates/runit/run.erb"
  ]
  s.homepage = "https://github.com/leifcr/capistrano-delayed_job"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Capistrano recipes for Delayed Job using runit and monit"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["~> 3.4"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<capistrano-monit_runit>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
    else
      s.add_dependency(%q<capistrano>, ["~> 3.4"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<capistrano-monit_runit>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<capistrano>, ["~> 3.4"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<capistrano-monit_runit>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
  end
end

