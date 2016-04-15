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
    @source = "vim/bundle"
  end

  def test_that_it_has_a_version_number
    refute_nil ::VundleMigrator::VERSION
  end

  def test_it_can_create_a_list_of_plugins
    FakeFS do
      setup_directories

      migrator = VundleMigrator::Migrator.new(@source, @destination)
      migrator.run

      assert_equal migrator.plugins.first, "Plugin 'trayo/vundle_migrator'"
    end
  end

  def test_it_can_create_a_plugins_file
    FakeFS do
      setup_directories
      vundle_begin = "call vundle#begin()"
      vundle_end = "call vundle#end()"

      migrator = VundleMigrator::Migrator.new(@source, @destination)
      migrator.run

      results = File.read("#{@destination}/plugins.vim")

      assert results =~ /.*#{vundle_begin}.*#{migrator.plugins.first}.*#{vundle_end}/m,
        "didn't find vundle commands '#{vundle_begin}' '#{migrator.plugins.first}' '#{vundle_end}' in: \n---\n#{results}\n---"
    end
  end

  def setup_directories
    FileUtils.mkdir_p(@destination)
    FileUtils.mkdir_p("#{@source}/test_plugin")
  end
end
