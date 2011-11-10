Lilp dependencies
=================

## Foreign dependencies ##
This file lists all the the dependencies of lilp.
The `optparse` library is used to handle the command line options.
The redcarpet library is a markdown parser with a very nice API.
We are going to use it in order to create the lilp renderer.

~~~~~~ ruby
require "optparse"
require 'redcarpet'
~~~~~~

## Local dependencies ##
Next, let's require our own files. They are located under the lilp/
directory.

~~~~~~ ruby
require 'lilp/version'
require 'lilp/base.rb'
~~~~~~
