Lilp: Lightweight Literate Programming
======================================

lilp is a literate programming pre-processor that allows you to write literate programs
using Markdown. In its current state, it is mainly an experiment, a toy.

This file is the main program file of the lilp application. Here is how we are going to
decompose it.

I propose we dive directly into the subject's by specifying how to parse and render source
code from lilp files. After that, we'll see how to handle option parsing for our command
line application. And lastly, we'll tie everything together.

## Parsing and rendering a lilp file ##

lilp files are simply files that end with a 'md' extension. They are valid markdown files.
In order to simplify the parsing phase, I am using the `redcarpet` library. This library
is easy to extend.

What we want to do is to create a 'render'. A render is an object that outputs a stream.
For that, it defines a number of hooks called by redcarpet's parser. What we need to do
is to specify a valid 'render' object, and make it output a program. Let's do that now.

* * *
_Literate Render_

Let's define here our render. It is a class that inherite from Redcarpet::Render::Base
	
	~~~~~~ ruby
	class LiterateRender < Redcarpet::Render::Base
		COMMENT_SIGN = "#  "
 	~~~~~~
	
Now, redcarpet's parser will call a number of hook, depending on what has been found
in the given lilp file. These hooks can be either `header`, `paragraph`, `block_code`
or other. Here is the formal specification: 
  
		```ruby
	  def preprocess(full_document)
	    @macro = {}
	    full_document
	  end
  
	  def header(text, header_level)
	    if header_level == 3
	      @macro[$1.to_sym] if text =~ /Call\: (.*)/
	    end
	  end

	  def paragraph(text)
	    text += "\n"
	    text.gsub(/^/, COMMENT_SIGN)
	  end

	  def block_code(code, language)
	    if @define_macro and @current_macro
	      @macro[@current_macro] = code += "\n"
	      code.gsub(/^/, COMMENT_SIGN)
	    else
	      code += "\n"
	    end
	  end
  
	  def hrule()
	    @define_macro  = ( not @define_macro )
	    @current_macro = nil if @define_macro
	  end
  
	  def emphasis(text)
	    @current_macro = text.to_sym if @define_macro
	    nil
	  end

	end
	```
	
The code above lists all the rules our render will live by. If there is anything to
change in our render, it's in this part of the code.

* * *

## Handle command line options ##

To a regular user, lilp is only a command he can invoke from the terminal. In order
to work with it, we need to get some information from the user, such as the files
he wants to preprocess, or the output directory where he wants the preprocessed files
to go.

For this, we use the `optparse` library. We create an Option object that uses that library's
API.

* * *
_The option parser_

	```ruby
	class Option
	  attr_reader :files, :params
  
	  def initialize( args )
	    @params = {}
	    @parser = OptionParser.new
	    @args   = args
    
	    @parser.banner = "Usage: lilp file_name.pl [other_file.pl] [-o output_dir]"
	    @parser.on("-o", "--output D", String, "Output directory") { |val| @params[:output] = File.join('.', "#{val}") }
	  end
  
	  def parse
	    begin
	      @files = @parser.parse(@args)
	      if @files.empty?
	        puts "Missing file names"
	        puts @parser
	        exit
	      end
	    rescue OptionParser::InvalidOption => opt
	      puts "Unknown option #{opt}"
	      puts @parser
	      exit
	    rescue OptionParser::MissingArgument => opt
	      puts opt
	      puts @parser
	      exit
	    end
	  end
	end
	```

* * *

## Put everything together ##

We have a lilp render class, an option class that takes care of the command line
options, now we need a way to tie the to together.

To do this, let's create a third object. The class will be "Runner". It's goal
is to render files passed to it while taking into account the options passed by
the command line.

* * *
_Runner class_

	```ruby
	class Runner
  
	  def run( params, files_path )
	    lilp_parser = Redcarpet::Markdown.new(LiterateRender)
    
	    files_path.each do |file_path|
	      puts "#{file_path}: "
      
	      if File.extname( file_path ) != '.md'
	        puts 'Skipping (file must have a .lp extension)'
	        next
	      end
      
	      output_path = String.new
	      if params[:output]
	        # Creates the output directory if it doesn't exist
	        if File.exists?(params[:output])
	          puts "Folder #{params[:output]} already exists"
	        else
	          puts "Creating folder #{params[:output]}"
	          Dir.mkdir(params[:output])
	        end
        
	        file_name   = File.basename(file_path).chomp( File.extname(file_path) )
	        output_path = File.join(params[:output], file_name)
	      else
	        output_path = file_path.chomp( File.extname(file_path) )
	      end
      
	      begin
	        file = File.open( file_path, 'r' )
	        out  = File.open( output_path, 'w' )
        
	        out.write( lilp_parser.render( file.read ) )
        
	        out.close
	        file.close
        
	        puts "Wrote #{output_path}"
        
	      rescue
	        puts "Error while parsing file '#{file_path}': #{$!}"
	      end
	    end

	  end
	end
	```

* * *

Now, the last thing we need to do is to attach each of the parts in the correct order, under
the Lilp module.

	```ruby
	module Lilp
	```

### Call: The option parser ###
### Call: Literate Render ###
### Call: Runner class ###

	```ruby
	end
	```