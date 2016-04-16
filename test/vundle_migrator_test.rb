$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vundle_migrator'
require 'vundle_migrator/version'

require 'minitest/autorun'
require 'minitest/pride'
require 'fakefs/safe'
require 'fileutils'

class VundleMigratorTest < Minitest::Test
  def setup
    @destination = "/vim/vundle"
    @source = "/vim/bundle"
    @vim_root = "/vim"
    @vimrc = "#{@vim_root}/vimrc"
  end

  def teardown
    FakeFS do
      FileUtils.rm_r("vim") if File.file?("vim")
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::VundleMigrator::VERSION
  end

  def test_it_can_create_a_list_of_plugins
    setup_directories
    plugin_list = "Plugin 'trayo/vundle_migrator'"

    FakeFS do
      migrator = VundleMigrator::Migrator.new(@vim_root, @source, @destination)

      migrator.create_plugins_list

      assert_equal plugin_list, migrator.plugins.first
    end
  end

  def test_it_can_create_the_vundle_folder
    setup_directories

    FakeFS do
      migrator = VundleMigrator::Migrator.new(@vim_root, @source, @destination)

      migrator.create_vundle_folder

      assert File.directory?(@destination), "#{@destination} wasn't created"
    end
  end

  def test_it_can_create_a_plugins_file
    setup_directories
    vundle_begin = "call vundle#begin()"
    vundle_end = "call vundle#end()"

    FakeFS do
      migrator = VundleMigrator::Migrator.new(@vimrc, @source, @destination)

      migrator.create_plugins_list
      migrator.create_vundle_folder
      migrator.create_plugins_file

      results = File.read("#{@destination}/plugins.vim")

      assert File.directory?(@destination), "#{@destination} wasn't created"
      assert results =~ /.*#{vundle_begin}.*#{migrator.plugins.first}.*#{vundle_end}/m, "didn't find vundle commands '#{vundle_begin}' '#{migrator.plugins.first}' '#{vundle_end}' in: \n---\n#{results}\n---"
    end
  end

  def test_it_can_prepend_to_the_vimrc
    results = ""
    final_vimrc = "source  ~/.vim/vundle/plugins.vim"
    existing_vimrc = "some cool stuff"

    FakeFS do
      setup_directories
      File.open(@vimrc, "w") do |f|
        f.write(existing_vimrc)
      end

      migrator = VundleMigrator::Migrator.new(@vimrc, @source, @destination)
      migrator.create_plugins_list
      migrator.create_vundle_folder
      migrator.create_plugins_file
      migrator.prepend_vimrc

      results = File.read(@vimrc)
    end

    assert results =~ /.*#{final_vimrc}.*#{existing_vimrc}/m, "expected vimrc:\n---\n#{final_vimrc}\n\n#{existing_vimrc}\n---\n\ndid not match: \n+++\n#{results}+++"
  end

  def setup_directories
    FakeFS do
      FileUtils.mkdir_p("#{@source}/test_plugin")
      FileUtils.mkdir_p(@vim_root)
      FileUtils.touch(@vimrc)
    end
  end
end
