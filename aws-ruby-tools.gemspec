# -*- encoding: utf-8 -*-
require File.expand_path('lib/aws-tools/version', File.dirname(__FILE__))

Gem::Specification.new do |gem|
  gem.authors       = ["Yamashita, Yuu"]
  gem.email         = ["yamashita@geishatokyo.com"]
  gem.description   = %q{Utility commands for AWS}
  gem.summary       = %q{Utility commands for AWS}
  gem.homepage      = "https://github.com/yyuu/aws-ruby-tools"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "aws-ruby-tools"
  gem.require_paths = ["lib"]
  gem.version       = AWSTools::VERSION

  gem.add_dependency("aws-sdk", "1.5.8")
end
