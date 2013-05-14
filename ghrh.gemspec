# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require 'ghrh/version'

Gem::Specification.new do |s|
  s.name        = "ghrh"
  s.version     = GHRH::VERSION

  s.authors     = ["Pranay Kanwar"]
  s.email       = "pranay.kanwar@gmail.com"
  s.homepage    = "https://github.com/r4um/ghrh"

  s.summary     = "Manage GitHub repository hooks"
  s.description = "Manage GitHub repository hooks easily on the commandline"

  s.required_rubygems_version = ">= 1.3.6"

  s.files = %x{git ls-files}.split("\n")
  s.test_files = %x{git ls-files -- spec/*}.split("\n")

  s.add_runtime_dependency 'clamp', "~> 0.6.1"
  s.add_runtime_dependency 'highline', '~> 1.6.19'
  s.add_runtime_dependency 'httparty', "~> 0.11.0"
  s.add_runtime_dependency 'json', '~> 1.7.7'
  s.add_runtime_dependency 'tabularize', '~> 0.2.9'

  s.add_development_dependency 'pry'

  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.executables  = ['ghrh']
  s.license = 'MIT'
end
