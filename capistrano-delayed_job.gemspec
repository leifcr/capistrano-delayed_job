# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "capistrano-delayed_job"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Leif Ringstad"]
  s.date = "2013-07-29"
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
    "lib/capistrano/delayed_job/config.rb",
    "lib/capistrano/delayed_job/monit.rb",
    "lib/capistrano/delayed_job/runit.rb",
    "templates/monit/delayed_job.conf.erb",
    "templates/runit/finish.erb",
    "templates/runit/log-run.erb",
    "templates/runit/run.erb"
  ]
  s.homepage = "https://github.com/leifcr/capistrano-delayed_job"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Capistrano recipes for Delayed Job using runit and monit"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.15.5"])
      s.add_runtime_dependency(%q<capistrano-base_helper>, [">= 0.0.8"])
      s.add_development_dependency(%q<bundler>, [">= 1.3.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.6"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.15.5"])
      s.add_dependency(%q<capistrano-base_helper>, [">= 0.0.8"])
      s.add_dependency(%q<bundler>, [">= 1.3.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.6"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.15.5"])
    s.add_dependency(%q<capistrano-base_helper>, [">= 0.0.8"])
    s.add_dependency(%q<bundler>, [">= 1.3.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.6"])
  end
end

