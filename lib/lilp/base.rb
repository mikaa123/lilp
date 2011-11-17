module Lilp

  class Option
    attr_reader :files, :params

    def initialize( args )
      @params = {}
      @parser = OptionParser.new
      @args   = args

      @parser.banner =
        "Usage: lilp file_name.pl [other_file.pl] [-o output_dir]"

      @parser.on("-o", "--output D", String, "Output directory") do |val|
        @params[:output] = File.join('.', "#{val}")
      end
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

  class LiterateRender < Redcarpet::Render::Base
    COMMENT_SIGN = "#  "

    def paragraph(text)
      text += "\n"
      text.gsub(/^/, COMMENT_SIGN)
    end

    def block_code(code, language)
      code += "\n"
    end

  end

  class Runner

    def run( params, files_path )
      lilp_parser = Redcarpet::Markdown.new(LiterateRender,
                      :fenced_code_blocks => true)

      files_path.each do |file_path|
        puts "#{file_path}: "

        if File.extname( file_path ) != '.md'
          puts 'Skipping (file must have a .md extension)'
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

          file_name   = File.basename(file_path).chomp(
                          File.extname(file_path) )

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

end
