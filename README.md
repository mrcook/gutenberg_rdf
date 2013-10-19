# Gutenberg RDF

Gutenberg RDF is a Ruby wrapper for the Project Gutenberg RDF catalog book files,
providing a nice API to all the metadata contained within.

## Requirements

*  Ruby 2.0 - this is so we get UTF-8 by default


## Installation

Add this line to your application's Gemfile:

    gem 'gutenberg_rdf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gutenberg_rdf

## Usage

    require 'gutenberg_rdf'

    book = GutenbergRdf.parse('/path/to/pg2746.rdf')

    puts book.id
    #=> "2746"

    puts book.type
    #=> "Text"

    puts book.title
    #=> "Urbain Grandier"

    puts book.subtitle
    #=> "Celebrated Crimes"

    puts book.authors.first.fullname
    #=> "Alexandre Dumas"

    puts book.subjects.first
    #=> "Crime"

    puts book.published
    #=> "2004-09-22"

    puts book.publisher
    #=> "Project Gutenberg"

    puts book.rights
    #=> "Public domain in the USA."

    puts book.language
    #=> "en"

    puts book.covers.first
    #=> "http://www.gutenberg.org/ebooks/2746.cover.medium"

    puts book.ebooks[3][:uri]
    #=> "http://www.gutenberg.org/ebooks/2746.epub.images"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
