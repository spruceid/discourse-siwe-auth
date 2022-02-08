# -*- encoding: utf-8 -*-
# stub: mkmfmf 0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "mkmfmf".freeze
  s.version = "0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Asher".freeze]
  s.date = "2010-10-28"
  s.description = "Fork of bundled mkmf.rb, should work as drop in replacement. Modifications: * GDB and XCode path compatibility: relative path specified by mkmf (../../../../ext/<target>/...) confuses source-to-debug correspondence. The downside to this is that mkmfmf specifies absolute paths, which means that the project will have to be recompiled for debugging from an alternate location. This can be disabled by adding a use_relative_paths block. * CURRENTLY NOT WORKING: Sub-directory support for source code: all .c, .m, .cc, .cxx., .cpp files and if the filesystem is case sensitive, all .C files are automatically included, and any directories with .h files are added to INCFLAGS. * Automatically uses CC from ENV if set".freeze
  s.email = "asher@ridiculouspower.com".freeze
  s.homepage = "http://rubygems.org/gems/mkmfmf".freeze
  s.rubygems_version = "3.2.31".freeze
  s.summary = "Fork of bundled mkmf.rb, should work as drop in replacement.".freeze

  s.installed_by_version = "3.2.31" if s.respond_to? :installed_by_version
end
