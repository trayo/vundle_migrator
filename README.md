# Vundle Migrator

[![Circle CI](https://circleci.com/gh/trayo/mv_listr.svg?style=svg)](https://circleci.com/gh/trayo/mv_listr)

Vundle Migrator is a tool that will migrate your current vim setup to use Vundle. It works by creating a `plugins.vim` that contains a list of your existing plugins from your bundle folder. The list will already be formatted in the vundle format: `Plugin "username/repo"`.

## Installation

`$ gem install vundle_migrator`

**Note:** When you have finished using Vundle Migrator, it can be uninstalled with `$ gem uninstall vundle_migrator`

## Usage

`$ ./vundle_migrate vimrc-location [OPTIONS]`

|Options|Requirement|Default Value|Description|
|---|---|---|---|
|-l, --vimrc-location|*Required*|None|Used to add a line to your vimrc that sources the final plugins.vim
|-b, --bundle-location|*Optional*|`~/.vim/bundle`|Used to build the list of plugins
|-d, --destination|*Required*|`~/.vim/vundle/plugins.vim`|Used as the destination of the plugins file.

#### Other Options

|Options|Description|
|---|---|
|-r, --dry-run|Displays the final result of the `plugins.vim` without modifying files.
|-h, --help|displays the help page
|-v, --version|displays the version

## Contributing

Issues and pull requests are welcome! Please try and submit them with a test demonstrating the issue.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

