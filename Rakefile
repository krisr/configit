# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'configit'

task :default => 'spec:run'

PROJ.name = 'configit'
PROJ.authors = 'Kris Rasmussen'
PROJ.email = 'kris@aptana.com'
PROJ.url = 'http://www.aptana.com'
PROJ.version = Configit::VERSION
PROJ.rubyforge.name = 'configit'
PROJ.ignore_file = '.gitignore'

PROJ.spec.opts << '--color'

# EOF
