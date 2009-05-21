# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osprey}
  s.version = "0.0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Leitgeb"]
  s.date = %q{2009-05-05}
  s.description = %q{Osprey interfaces with the Twitter search API and keeps track of tweets you've seen}
  s.email = %q{justin@phq.org}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  
  s.files = ["lib/core_ext/array.rb", "lib/core_ext/hash.rb", "lib/osprey/result_set.rb", 
    "lib/osprey/search.rb", "lib/osprey/tweet.rb", "lib/osprey.rb", "LICENSE", "osprey-0.0.7.gem", 
    "osprey.gemspec", "Rakefile", "README.rdoc", "spec/fixtures/swine_flu1.json", "spec/fixtures/swine_flu2.json", 
    "spec/fixtures/swine_flu_result_set1.yml", "spec/fixtures/swine_flu_result_set2.yml", 
    "spec/osprey/result_set_spec.rb", "spec/osprey/search_spec.rb", "spec/osprey_spec.rb", 
    "spec/spec_helper.rb", "VERSION.yml"]
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jsl/osprey}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Twitter API that keeps track of tweets you've seen}
  s.test_files = ["spec/fixtures/swine_flu1.json", "spec/fixtures/swine_flu2.json", 
    "spec/fixtures/swine_flu_result_set1.yml", "spec/fixtures/swine_flu_result_set2.yml", 
    "spec/osprey/result_set_spec.rb", "spec/osprey/search_spec.rb", "spec/osprey_spec.rb", "spec/spec_helper.rb"]

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
