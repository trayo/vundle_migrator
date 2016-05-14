module VundleMigrator
  def self.migrate(opts)
    Migrator.new(opts[:vimrc_location], opts[:bundle_location], opts[:vundle_destination]).run
  end

  def self.dry_run(opts)
    Migrator.new(opts[:vimrc_location], opts[:bundle_location], opts[:vundle_destination]).dry_run
  end

  class Migrator
    attr_reader :plugins

    VIMRC_SOURCE = "\" load vundle plugins\n" \
                   "source  ~/.vim/vundle/plugins.vim\n\n"

    PLUGINS_START = "set nocompatible\n" \
                    "filetype off\n" \
                    "set rtp+=~/.vim/bundle/Vundle.vim\n\n" \
                    "call vundle#begin()\n\n"

    PLUGINS_END = "\ncall vundle#end()\n\n" \
                  "filetype plugin indent on"

    def initialize(vimrc, source, destination)
      @vimrc = vimrc
      @source = source || "#{Dir.home}/.vim/bundle"
      @destination = destination || "#{Dir.home}/.vim/vundle/plugins.vim"
      @entries = Dir.entries(@source) - %w(. ..)
      @plugins = []
    end

    def run
      create_plugins_list
      create_vundle_folder
      create_plugins_file
      prepend_vimrc
    end

    def dry_run
      create_plugins_list
      print_file_contents
    end

    def create_plugins_list
      @plugins = @entries.map do |plugin_directory|
        Dir.chdir("#{@source}/#{plugin_directory}") do
          package = `git remote -v`.match(/com[\/|:](.+)\.git/)[1]
          "Plugin '#{package}'"
        end
      end
    end

    def create_vundle_folder
      FileUtils.mkdir_p(File.dirname(@destination))
    end

    def create_plugins_file
      File.open(@destination, "w") do |f|
        f.write(PLUGINS_START)

        @plugins.each do |plugin|
          f.write("#{plugin}\n")
        end

        f.write(PLUGINS_END)
      end
    end

    def prepend_vimrc
      File.rename("#{@vimrc}", "#{@vimrc}.old")

      File.open("#{@vimrc}", 'w') do |f|
        f.puts VIMRC_SOURCE
        File.foreach("#{@vimrc}.old") do |l|
          f.puts l
        end
      end

      FileUtils.remove("#{@vimrc}.old")
    end

    def print_file_contents
      puts PLUGINS_START
      puts @plugins
      puts PLUGINS_END
    end
  end
end
