Lightweight Literate programming
================================

lilp is a preprocessor that allows you to write literate programming code using the Markdown syntax.

lilp extracts the code from your markdown files.

## How it works

Simply write your source file as if you were writing a normal Markdown document.

~~~~ ruby
puts "code inside code blocks will be extracted, while the rest will
      be tranformed as comments"
~~~~

Everything but code blocks will be transformed as comments.

## Installation

~~~~
gem install lilp
~~~~

## Usage
To run lilp against a markdown file, use the `lilp` command like this:

~~~~
lilp file_name.rb.md -o output_dir/
~~~~

This will extract the code from `file_name.rb.md`, and put it in `output_dir/file_name.rb`.

Your markdown files have to be named '.[language_extension].md'

## Example
https://github.com/mikaa123/lilplateform

## License

Copyright (C) 2011 Michael Sokol

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
