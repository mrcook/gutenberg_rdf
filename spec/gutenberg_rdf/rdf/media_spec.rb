require 'spec_helper'

module GutenbergRdf
  class Rdf
    describe Media do

      let(:xml) do
        '<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/98765.txt.utf-8">
            <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">293684</dcterms:extent>
            <dcterms:format>
              <rdf:Description>
                <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain; charset=utf-8</rdf:value>
              </rdf:Description>
            </dcterms:format>
            <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
            <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2010-02-16T08:29:52.373092</dcterms:modified>
          </pgterms:file>
        </rdf:RDF>'
      end
      let(:media) { Media.new(REXML::Document.new(xml).elements['rdf:RDF/pgterms:file']) }

      it "expects the file URI" do
        expect(media.uri).to eql 'http://www.gutenberg.org/ebooks/98765.txt.utf-8'
      end
      it "expects the file media type" do
        expect(media.media_type).to eql 'text/plain'
      end
      it "expects the file encoding" do
        expect(media.encoding).to eql 'utf-8'
      end
      it "expects modified to be a DateTime" do
        expect(media.modified.class).to be DateTime
      end
      it "should return the modified datetime" do
        expect(media.modified.to_s).to eql '2010-02-16T08:29:52-07:00'
      end

      context "when there are two media types" do
        let(:xml) do
          '<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
             <pgterms:file rdf:about="http://www.gutenberg.org/files/98765/98765.zip">
               <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">116685</dcterms:extent>
               <dcterms:format>
                 <rdf:Description>
                   <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                   <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">application/zip</rdf:value>
                   <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain; charset=us-ascii</rdf:value>
                 </rdf:Description>
               </dcterms:format>
               <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
               <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2006-09-28T12:37:26</dcterms:modified>
             </pgterms:file>
          </rdf:RDF>'
        end
        let(:media) { Media.new(REXML::Document.new(xml).elements['rdf:RDF/pgterms:file']) }

        it "expects the first entry to be used" do
          expect(media.media_type).to eql 'application/zip'
        end
        it "expects the encoding to be an empty string" do
          expect(media.encoding).to eql ''
        end
      end

    end
  end
end
