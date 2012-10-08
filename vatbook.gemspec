# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vatbook/version'

Gem::Specification.new do |gem|
  gem.name          = "vatbook"
  gem.version       = Vatbook::VERSION
  gem.authors       = ["Svilen Vassilev"]
  gem.email         = ["svilen@rubystudio.net"]
  gem.description   = %q{Ruby API to the Vatbook service for reading Vatsim pilot and ATC bookings}
  gem.summary       = %q{Ruby API to the Vatbook service for reading Vatsim pilot and ATC bookings}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "libnotify"
  gem.add_development_dependency "guard-rspec"
end
