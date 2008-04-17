%w(rubygems rake rake/clean rake/packagetask rake/gempackagetask rake/rdoctask fileutils pp).each{|dep|require dep}

include FileUtils

namespace 'spec' do
  desc "generate spec"
  task :gen do
    sh "bacon -rlib/aurora -rtest/spec_helper test/**/* -s > test/SPEC"
  end
  
  desc "run rspec"
  task :run do
    sh "bacon -r~/lib/bacon/output -rlib/aurora -rtest/spec_helper test/**/* -o CTestUnit"
  end
  
  desc "run rspec verbosely"
  task :verb do
    sh "bacon -r~/lib/bacon/output -rlib/aurora -rtest/spec_helper test/**/* -o CSpecDox"
  end
end

desc "Generate RDoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README' <<
    '--title' << 'Aurora Documentation' <<
    '--charset' << 'utf-8'
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include 'README'
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('app/*.rb')
  rdoc.rdoc_files.include('config/*.rb')
end

desc "find . -name \"*.rb\" | xargs wc -l | grep total"
task :loc do
  sh "find . -name \"*.rb\" | xargs wc -l | grep total"
end

task :default => Rake::Task['spec:run']
