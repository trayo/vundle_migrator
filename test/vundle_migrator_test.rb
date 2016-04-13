$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vundle_migrator'
require 'vundle_migrator/version'

require 'minitest/autorun'
require 'minitest/pride'
require 'fakefs/safe'
require 'fileutils'

class VundleMigratorTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::VundleMigrator::VERSION
  end

  def test_it_can_create_a_list_of_plugins
    FakeFS do
      destination = "/"
      bundle = "vim/bundle"
      FileUtils.mkdir_p("#{bundle}/test_plugin")

      migrator = VundleMigrator::Migrator.new(destination, bundle)
      migrator.run

      assert_equal migrator.plugins.first, "Plugin 'trayo/vundle_migrator'"
    end
  end
end
