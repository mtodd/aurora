%w(rubygems rake rake/clean rake/packagetask rake/gempackagetask rake/rdoctask fileutils pp halcyon).each{|dep|require dep}

include FileUtils

desc "Load the application environment"
task :environment do
  Halcyon::Application.boot do |c|
    if ENV['HALCYON_ENV']
      c[:environment] = ENV['HALCYON_ENV'].to_sym
    end
  end
end

desc "Start up the application"
task :app => [:environment] do
  # run the startup hooks et al
  $app = Halcyon::Application.new
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

namespace 'db' do
  
  desc "Connect to the database"
  task :connect => [:environment] do
    Aurora::DB = Sequel.connect(Halcyon.db)
    Aurora::DB.logger = self.logger if $DEBUG
  end
  
  desc "Migrate the database"
  task :migrate => [:connect] do
    puts "Running migrations"
    puts "="*80
    
    current_version = Sequel::Migrator.get_current_migration_version(Aurora::DB)
    latest_version = Sequel::Migrator.apply(Aurora::DB, Halcyon.root/'db'/'migrations')
    if current_version < latest_version
      puts "Database migrations loaded"
      puts "v#{current_version} => v#{latest_version}"
    else
      puts "No migrations run"
    end
    
    puts "="*80
    puts "Finished!"
  end
  
end

namespace 'fs' do
  
  desc "Creates empty log files"
  task :logs do
    touch %w(log/development.log log/test.log log/production.log)
  end
  
end

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

namespace 'debug' do
  
  desc "Display the configuration"
  task :config => [:environment] do
    require 'pp'
    pp Halcyon.config
  end
  
end

desc "find . -name \"*.rb\" | xargs wc -l | grep total"
task :loc do
  sh "find . -name \"*.rb\" | xargs wc -l | grep total"
end

# task :default => Rake::Task['spec:run']
