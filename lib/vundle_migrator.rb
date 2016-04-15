module VundleMigrator
  def self.migrate(args)
    Migrator.new(args).run
  end

  class Migrator
    attr_reader :plugins

    VIMRC_SOURCE = "\" load vundle plugins\n" \
                   "source  ~/.vim/vundle/plugins.vim"

    PLUGINS_START = "set nocompatible\n" \
                    "filetype off\n" \
                    "set rtp+=~/.vim/bundle/Vundle.vim\n\n" \
                    "call vundle#begin()\n\n"

    PLUGINS_END = "\n\ncall vundle#end()\n\n" \
                  "filetype plugin indent on"

    def initialize(source="#{Dir.home}/.vim/bundle", destination="#{Dir.home}/.vim/vundle")
      @destination = destination
      @source = source
      @entries = Dir.entries(source) - %w(. ..)
      @plugins = []
    end

    def run
      create_plugins_list
      create_plugins_file
    end

    private

      def create_plugins_list
        @entries.each do |plugin_directory|
          Dir.chdir("#{@source}/#{plugin_directory}") do
            package = `git remote -v`.match(/com[\/|:](.+)\.git/)[1]
            @plugins << "Plugin '#{package}'"
          end
        end
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
  end
end
