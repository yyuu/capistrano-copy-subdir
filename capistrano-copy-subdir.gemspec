# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano/recipes/deploy/strategy/copy_subdir/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yamashita Yuu"]
  gem.email         = ["yamashita@geishatokyo.com"]
  gem.description   = %q{a capistrano strategy to deploy subdir with copy strategy.}
  gem.summary       = %q{a capistrano strategy to deploy subdir with copy strategy.}
  gem.homepage      = "https://github.com/yyuu/capistrano-copy-subdir"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-copy-subdir"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Deploy::Strategy::CopySubdir::VERSION

  gem.add_dependency("capistrano")
end
