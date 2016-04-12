$:.unshift File.dirname(__FILE__) + '/../lib'

require "vundle_migrator/version"

Gem::Specification.new do |spec|
  spec.name          = "vundle_migrator"
  spec.version       = VundleMigrator::VERSION
  spec.authors       = ["Travis Yoder"]
  spec.email         = ["trayoda@gmail.com"]

  spec.summary       = "Vundle Migrator will automatically create a list of  plugins from your bundle folder."
  spec.homepage      = "https://github.com/trayo/vundle_migrator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables = ["vundle_migrator"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "slop", "~> 4.3.0"
end
