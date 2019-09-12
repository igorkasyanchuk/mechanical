$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "mechanical/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mechanical"
  spec.version     = Mechanical::VERSION
  spec.authors     = ["Igor Kasyanchuk"]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  spec.homepage    = "https://github.com/igorkasyanchuk/mechanical"
  spec.summary     = "Forms / DB / Model"
  spec.description = "Dynamic forms, schema, everything stored in DB"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.2.0"
  spec.add_dependency "simple_form"
  spec.add_dependency "dry-schema"
  spec.add_dependency "dry-struct"
  spec.add_dependency "dry-types"
  spec.add_dependency "dry-validation"
  spec.add_dependency "activemodel-form"
  spec.add_dependency "active_attr"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "pry"
end
