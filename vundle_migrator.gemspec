lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vundle_migrator/version'

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

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "fakefs", "~> 0.8.1"
  spec.add_development_dependency "minitest", "~> 5.8.4"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "rake", "~> 11.1.2"
  spec.add_development_dependency "slop", "~> 4.3.0"
end
