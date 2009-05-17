# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osprey}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Leitgeb"]
  s.date = %q{2009-05-05}
  s.description = %q{Osprey interfaces with the Twitter search API and keeps track of tweets you've seen}
  s.email = %q{justin@phq.org}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  
  s.files = Dir['lib/**/*.rb'] + Dir['[A-Z]*'] + Dir['spec/**/*']
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jsl/osprey}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Twitter API that keeps track of tweets you've seen}
  s.test_files = Dir['spec/**/*']

  s.extra_rdoc_files = [ "README.rdoc" ]
  
  s.rdoc_options += [
    '--title', 'Osprey',
    '--main', 'README.rdoc',
    '--line-numbers',
    '--inline-source'
   ]

  %w[ curb wycats-moneta hashback json memcache-client ].each do |dep|
    s.add_dependency(dep)
  end

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
