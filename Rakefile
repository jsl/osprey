require 'rubygems'
require 'spec'

require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

require 'lib/osprey'

desc 'Test the plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts  = ["--format", "progress", "--colour"]
  t.libs << 'lib'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "osprey"
    gemspec.summary = "A Twitter API that keeps track of tweets you've seen"
    gemspec.email = "justin@phq.org"
    gemspec.homepage = "http://github.com/jsl/osprey"
    gemspec.description = "Osprey interfaces with the Twitter search API and keeps track of tweets you've seen"
    gemspec.authors = ["Justin Leitgeb"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc "Run all the tests"
task :default => :spec

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Osprey'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/osprey/**/*.rb')
end

