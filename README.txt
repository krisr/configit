configit
    by Kris Rasmussen
    http://www.aptana.com

== DESCRIPTION:

The purpose of this gem is to make it very easy to consume configuration files
and define them.

== FEATURES/PROBLEMS:

* Easilly define config attributes directly on the class
* Provides validation of configs
* Automatically converts attributes to the correct type
* Enables you to access attribute values as attributes on the class instance
* Load config from files, strings, or IO
* Can turn on or off ERB evaluation before loading from yaml
* Treats strings / symbol keys as equivalent from yaml config

== SYNOPSIS:

  class MyConfig << Configit::Base
    attribute :foo, :required => true
    attribute :bar, "Some description", :type => :integer, :default => 10
    attribute :log_level, "Set the log level", :default => :debug, :type => :symbol
  end

  config = MyConfig.load_from_file("/etc/myconfig")
  
  config.foo
  config.bar
  config.log_level

  config.foo = "new value"

  config.valid # true or false
  config.errors.each do |error|
    puts error.message
    puts error.attribute.name
  end

== REQUIREMENTS:

== TODO:

* Implement type validation
* Enable easy printing of errors
* Add colorization to error messages

== INSTALL:

  sudo gem install krisr-configit --source gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2009 Kris Rasmussen

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
