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
                    "call vundle#begin()\n"

    PLUGINS_END = "call vundle#end()\n\n" \
                  "filetype plugin indent on"

    def initialize(destination="#{Dir.home}/.vim/vundle", bundle="#{Dir.home}/.vim/bundle")
      @destination = destination
      @bundle = bundle
      @entries = Dir.entries(bundle) - %w(. ..)
      @plugins = []
    end

    def run
      @entries.each do |plugin_directory|
        Dir.chdir("#{@bundle}/#{plugin_directory}") do
          package = `git remote -v`.match(/com[\/|:](.+)\.git/)[1]
          @plugins << "Plugin '#{package}'"
        end
      end
    end
  end
end
