require 'spec_helper'

module GutenbergRdf
  RSpec.describe ".parse" do
    let(:file) { StringIO.new('<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><pgterms:ebook rdf:about="ebooks/98765"/></rdf:RDF>') }

    it "expects an Rdf object" do
      allow(File).to receive(:new).and_return(file)
      book = GutenbergRdf.parse(file)

      expect(book.class).to be Rdf
      expect(book.id).to eql '98765'
    end

  end
end
