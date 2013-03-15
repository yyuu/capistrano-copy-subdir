# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/recipes/deploy/strategy/copy_subdir/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-copy-subdir"
  gem.version       = Capistrano::Deploy::Strategy::COPY_SUBDIR_VERSION
  gem.authors       = ["Yamashita Yuu"]
  gem.email         = ["yamashita@geishatokyo.com"]
  gem.description   = %q{a capistrano strategy to deploy subdir with copy strategy.}
  gem.summary       = %q{a capistrano strategy to deploy subdir with copy strategy.}
  gem.homepage      = "https://github.com/yyuu/capistrano-copy-subdir"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("capistrano")
  gem.add_development_dependency("net-scp", "~> 1.0.4")
  gem.add_development_dependency("net-ssh", "~> 2.2.2")
  gem.add_development_dependency("vagrant", "~> 1.0.6")
end
