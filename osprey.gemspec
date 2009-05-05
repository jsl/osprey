# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osprey}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Leitgeb"]
  s.date = %q{2009-05-04}
  s.description = %q{Osprey interfaces with the Twitter search API and keeps track of tweets you've seen}
  s.email = %q{justin@phq.org}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "Rakefile",
    "lib/core_ext/array.rb",
    "lib/core_ext/hash.rb",
    "lib/osprey.rb",
    "lib/osprey/backend/dev_null.rb",
    "lib/osprey/backend/filesystem.rb",
    "lib/osprey/backend/memcache.rb",
    "lib/osprey/backend/memory.rb",
    "lib/osprey/result_set.rb",
    "lib/osprey/tweet.rb",
    "lib/osprey/search.rb",
    "spec/fixtures/result_set.yml",
    "spec/fixtures/swine_flu1.json",
    "spec/fixtures/swine_flu2.json",
    "spec/osprey/backend/dev_null_spec.rb",
    "spec/osprey/backend/filesystem_spec.rb",
    "spec/osprey/backend/memcache_spec.rb",
    "spec/osprey/backend/memory_spec.rb",
    "spec/osprey/result_set_spec.rb",
    "spec/osprey/twitter_reader_spec.rb",
    "spec/osprey_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jsl/osprey}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Twitter API that keeps track of tweets you've seen}
  s.test_files = [
    "spec/osprey/backend/dev_null_spec.rb",
    "spec/osprey/backend/filesystem_spec.rb",
    "spec/osprey/backend/memcache_spec.rb",
    "spec/osprey/backend/memory_spec.rb",
    "spec/osprey/result_set_spec.rb",
    "spec/osprey/search_spec.rb",
    "spec/osprey_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
