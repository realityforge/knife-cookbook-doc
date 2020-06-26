require 'bundler/gem_tasks'
require 'rake/clean'

task :default => :build

CLEAN.include 'pkg'

task :test => :install
task :test do
  sh <<SCRIPT
cd fixture
knife cookbook doc . -o README-generated.md -c knife.rb
diff -u README-expected.md README-generated.md && rm README-generated.md
SCRIPT
end
