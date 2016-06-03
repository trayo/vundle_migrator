require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.warning = false
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

desc "Build the docker image"
task :docker_build do
  gem_version=`cat lib/vundle_migrator/version.rb`.match(/\d\.\d\.\d/)[0]
  puts %x[docker build --build-arg GEM_VERSION=#{gem_version} -t vundle_migrator .]
end
task :docker_build_image => :docker_build

desc "Run the vundle_migrator binary in docker"
task :docker_run do
  puts %x[docker run -it --rm vundle_migrator bin/vundle_migrator -l /root/.vimrc]
end

desc "Run the vundle_migrator binary with the dry_run flag in docker"
task :docker_dry_run do
  puts %x[docker run -it --rm vundle_migrator bin/vundle_migrator -l /root/.vimrc -r]
end
