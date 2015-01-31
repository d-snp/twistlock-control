# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
	spec.name          = 'twistlock-control'
	spec.version       = TwistlockControl::VERSION
	spec.authors       = ['Tinco Andringa']
	spec.email         = ['mail@tinco.nl']
	spec.description   = '{TODO: Write a gem description'
	spec.summary       = 'TODO: Write a gem summary'
	spec.homepage      = ''
	spec.license       = 'MIT'

	spec.files         = `git ls-files`.split($RS)
	spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(/^(test|spec|features)/)
	spec.require_paths = ['lib']

	spec.add_development_dependency 'bundler', '~> 1.3'
	spec.add_development_dependency 'rake'

	{
		'rethinkdb' => nil,
		'connection_pool' => nil,
		'virtus' => nil
	}.each { |k, v| spec.add_dependency(k, v) }
end
