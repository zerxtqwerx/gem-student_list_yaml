require_relative 'lib/students_list_yaml/version'

Gem::Specification.new do |spec|
  spec.name          = "students_list_yaml"
  spec.version       = StudentsListYAML::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "YAML-based student list management"
  spec.description   = "A gem for managing student lists using YAML format"
  spec.homepage      = "https://github.com/yourusername/students_list_yaml"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]

  spec.add_dependency "psych", "~> 3.3"
end