# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{configit}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kris Rasmussen"]
  s.date = %q{2010-02-17}
  s.default_executable = %q{configit}
  s.description = %q{The purpose of this gem is to make it very easy to consume configuration files
and define them.}
  s.email = %q{kris@aptana.com}
  s.executables = ["configit"]
  s.extra_rdoc_files = ["History.txt", "README.txt", "bin/configit"]
  s.files = [".DS_Store", ".bnsignore", "History.txt", "README.txt", "Rakefile", "bin/configit", "configit.gemspec", "lib/configit.rb", "lib/configit/attribute_definition.rb", "lib/configit/base.rb", "lib/configit/exceptions.rb", "spec/configit/base_spec.rb", "spec/configit_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "test/test_configit.rb"]
  s.homepage = %q{http://www.aptana.com}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{configit}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{The purpose of this gem is to make it very easy to consume configuration files and define them}
  s.test_files = ["test/test_configit.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.5.1"])
    else
      s.add_dependency(%q<bones>, [">= 2.5.1"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.5.1"])
  end
end
