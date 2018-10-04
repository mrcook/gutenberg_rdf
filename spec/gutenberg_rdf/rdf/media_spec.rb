require 'spec_helper'

module GutenbergRdf
  class Rdf
    RSpec.describe Media do
      let(:xml) do
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:ebook rdf:about="ebooks/98765">
            <dcterms:hasFormat>
              <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/98765.txt.utf-8">
                <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">293684</dcterms:extent>
                <dcterms:format>
                  <rdf:Description rdf:nodeID="N87dfy78yd78s6gsg6f8970d76g0f6d9b">
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain; charset=utf-8</rdf:value>
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2010-02-16T08:29:52.373092</dcterms:modified>
              </pgterms:file>
            </dcterms:hasFormat>
          </pgterms:ebook>
        </rdf:RDF>'
      end
      let(:media) { Media.new(REXML::Document.new(xml).elements['rdf:RDF/pgterms:ebook/dcterms:hasFormat/pgterms:file']) }

      it 'expects the file URI' do
        expect(media.uri).to eql 'http://www.gutenberg.org/ebooks/98765.txt.utf-8'
      end
      it 'expects the file media type' do
        expect(media.media_type).to eql 'text/plain'
      end
      it 'expects the file encoding' do
        expect(media.encoding).to eql 'utf-8'
      end
      it 'expects modified to be a DateTime' do
        expect(media.modified.class).to be DateTime
      end
      it 'should return the modified datetime' do
        expect(media.modified.to_s).to eql '2010-02-16T08:29:52-07:00'
      end
    end
  end
end
