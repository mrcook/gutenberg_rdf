require 'rexml/document'

require "gutenberg_rdf/rdf"
require "gutenberg_rdf/rdf/agent"
require "gutenberg_rdf/rdf/media"
require "gutenberg_rdf/version"

module GutenbergRdf

  def self.parse(path)
    Rdf.new(REXML::Document.new(File.new(path)))
  end

end
