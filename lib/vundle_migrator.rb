module VundleMigrator
  def self.migrate(args)
    Migrator.new(args).run
  end

  class Migrator
    attr_reader :plugins

    VIMRC_SOURCE = "\" load vundle plugins\n" \
                   "source  ~/.vim/vundle/plugins.vim\n\n"

    PLUGINS_START = "set nocompatible\n" \
                    "filetype off\n" \
                    "set rtp+=~/.vim/bundle/Vundle.vim\n\n" \
                    "call vundle#begin()\n\n"

    PLUGINS_END = "\n\ncall vundle#end()\n\n" \
                  "filetype plugin indent on"

    def initialize(vimrc, source="#{Dir.home}/.vim/bundle", destination="#{Dir.home}/.vim/vundle")
      @vimrc = vimrc
      @source = source
      @destination = destination
      @entries = Dir.entries(source) - %w(. ..)
      @plugins = []
    end

    def run
      create_plugins_list
      create_vundle_folder
      create_plugins_file
      prepend_vimrc
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
      FileUtils.mkdir_p(@destination)
    end

    def create_plugins_file
      File.open("#{@destination}/plugins.vim", "w") do |f|
        f.write(PLUGINS_START)

        @plugins.each do |plugin|
          f.write(plugin)
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
  end
end
