require 'nokogiri'

require "gutenberg_rdf/rdf"
require "gutenberg_rdf/rdf/agent"
require "gutenberg_rdf/version"

module GutenbergRdf

  def self.parse(path)
    Rdf.new(Nokogiri::XML(File.new(path)))
  end

end
