require 'spec_helper'

module GutenbergRdf
  describe Rdf do
    let(:xml) do
      '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2006-09-28</dcterms:issued>
             <dcterms:language rdf:datatype="http://purl.org/dc/terms/RFC4646">en</dcterms:language>
             <dcterms:publisher>Project Gutenberg</dcterms:publisher>
             <dcterms:rights>Public domain in the USA.</dcterms:rights>
           </pgterms:ebook>
       </rdf:RDF>'
    end
    let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

    it "expects an id" do
      expect(rdf.id).to eql "98765"
    end
    it "expects a published date" do
      expect(rdf.published).to eql "2006-09-28"
    end
    it "expects a publisher" do
      expect(rdf.publisher).to eql "Project Gutenberg"
    end
    it "expects a language" do
      expect(rdf.language).to eql "en"
    end
    it "expects the rights" do
      expect(rdf.rights).to eql "Public domain in the USA."
    end

    describe "#type" do
      let(:xml) do
        '<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:type>
               <rdf:Description>
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/DCMIType"/>
                 <rdf:value>Text</rdf:value>
               </rdf:Description>
             </dcterms:type>
           </pgterms:ebook>
         </rdf:RDF>'
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "expect the type of entity" do
        expect(rdf.type).to eql 'Text'
      end
    end

    describe "Titles" do
      let(:xml) do
        '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:title>A Great Title</dcterms:title>
           </pgterms:ebook>
         </rdf:RDF>'
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "expects a title" do
        expect(rdf.title).to eql 'A Great Title'
      end
      it "expects subtitle to be empty" do
        expect(rdf.subtitle).to eql ''
      end

      context "with a title and subtitle, on separate lines" do
        let(:xml) do
          '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/98765">
              <dcterms:title>A Great Multi-Title
                Or, a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects the title to be the first line" do
          expect(rdf.title).to eql 'A Great Multi-Title'
        end
        it "expects the subtitle to be the second line" do
          expect(rdf.subtitle).to eql 'Or, a Subtitle'
        end
      end

      context "when title:subtitle are separated by a colon" do
        let(:xml) do
          '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/98765">
              <dcterms:title>A Great Multi-Title: And a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects a title" do
          expect(rdf.title).to eql 'A Great Multi-Title'
        end
        it "expects a subtitle" do
          expect(rdf.subtitle).to eql 'And a Subtitle'
        end
      end

      context "when title; and subtitle are separated by a semi-colon" do
        let(:xml) do
          '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/98765">
              <dcterms:title>A Great Multi-Title; Or, a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }
        it "expects a title" do
          expect(rdf.title).to eql 'A Great Multi-Title'
        end
        it "expects a subtitle" do
          expect(rdf.subtitle).to eql 'Or, a Subtitle'
        end

        context "...except when subtitles already exists" do
          let(:xml) do
            '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/98765">
              <dcterms:title>A Great Multi-Title; and some other text
                Then a Subtitle on a newline</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
          end
          let(:rdf) { Rdf.new(REXML::Document.new(xml)) }
          it "expects a title" do
            expect(rdf.title).to eql 'A Great Multi-Title; and some other text'
          end
          it "expects a subtitle" do
            expect(rdf.subtitle).to eql 'Then a Subtitle on a newline'
          end
        end
      end
    end

    describe "#authors" do
      let(:xml) do
        '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:agent rdf:about="2009/agents/402">
            <pgterms:birthdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1830</pgterms:birthdate>
            <pgterms:deathdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1905</pgterms:deathdate>
            <pgterms:name>Dodge, Mary Mapes</pgterms:name>
            <pgterms:alias>Dodge, Mary</pgterms:alias>
            <pgterms:webpage rdf:resource="http://en.wikipedia.org/wiki/Mary_Mapes_Dodge"/>
          </pgterms:agent>
          <pgterms:agent rdf:about="2009/agents/116">
            <pgterms:alias>Verschillende</pgterms:alias>
            <pgterms:name>Various</pgterms:name>
          </pgterms:agent>
        </rdf:RDF>'
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "expects a Array" do
        expect(rdf.authors.class).to be Array
      end
      it "expects correct number to be returned" do
        expect(rdf.authors.count).to be 2
      end
      it "expects an author object" do
        expect(rdf.authors.first.class).to be Rdf::Agent
      end
    end

    describe "#subjects" do
      let(:xml) do
        %q{<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:subject>
               <rdf:Description>
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/LCSH"/>
                 <rdf:value>Children's literature -- Periodicals</rdf:value>
                 <rdf:value>Children's periodicals, American</rdf:value>
               </rdf:Description>
             </dcterms:subject>
             <dcterms:subject>
               <rdf:Description>
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/LCC"/>
                 <rdf:value>PZ</rdf:value>
               </rdf:Description>
             </dcterms:subject>
           </pgterms:ebook>
        </rdf:RDF>}
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }
      it "expects correct number to be returned" do
        expect(rdf.subjects.count).to be 2
      end
      it "expects the correct data" do
        expect(rdf.subjects.first).to eql "Children's literature -- Periodicals"
        expect(rdf.subjects.last).to eql "Children's periodicals, American"
      end
    end

    describe "#covers" do
      describe "official PG covers" do
        let(:xml) do
          '<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
             <pgterms:ebook rdf:about="ebooks/12345">
               <dcterms:hasFormat rdf:resource="http://www.gutenberg.org/ebooks/12345.epub.noimages"/>
               <dcterms:hasFormat rdf:resource="http://www.gutenberg.org/ebooks/12345.cover.medium"/>
               <dcterms:hasFormat rdf:resource="http://www.gutenberg.org/ebooks/12345.cover.small"/>
               <pgterms:marc901>http://www.gutenberg.org/files/12345/12345-h/images/cover.jpg</pgterms:marc901>
             </pgterms:ebook>
             <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/12345.epub.noimages">
               <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">92652</dcterms:extent>
               <dcterms:format>
                 <rdf:Description>
                   <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                   <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">application/epub+zip</rdf:value>
                 </rdf:Description>
               </dcterms:format>
               <dcterms:isFormatOf rdf:resource="ebooks/12345"/>
               <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-09-21T19:22:32.115259</dcterms:modified>
             </pgterms:file>
             <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/12345.cover.medium">
               <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">10856</dcterms:extent>
               <dcterms:format>
                 <rdf:Description>
                   <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                   <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">image/jpeg</rdf:value>
                 </rdf:Description>
               </dcterms:format>
               <dcterms:isFormatOf rdf:resource="ebooks/12345"/>
               <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-09-21T19:22:34.484114</dcterms:modified>
             </pgterms:file>
             <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/12345.cover.small">
               <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1904</dcterms:extent>
               <dcterms:format>
                 <rdf:Description>
                   <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                   <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">image/jpeg</rdf:value>
                 </rdf:Description>
               </dcterms:format>
               <dcterms:isFormatOf rdf:resource="ebooks/12345"/>
               <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-09-21T19:22:34.379124</dcterms:modified>
             </pgterms:file>
           </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects the correct number of entries returned" do
          expect(rdf.covers.count).to be 3
        end
        it "expects those to be used" do
          expect(rdf.covers[0]).to eql 'http://www.gutenberg.org/ebooks/12345.cover.medium'
          expect(rdf.covers[1]).to eql 'http://www.gutenberg.org/ebooks/12345.cover.small'
        end
        it "expects any other images to be listed after the official ones" do
          expect(rdf.covers[2]).to eql 'http://www.gutenberg.org/files/12345/12345-h/images/cover.jpg'
        end
      end

      describe "HTML ebook cover image" do
        let(:xml) do
          '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
             <pgterms:ebook rdf:about="ebooks/12345">
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/12345/12345-rst/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/12345/12345-h/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>http://www.gutenberg.org/files/12345/12345-h/images/cover.jpg</pgterms:marc901>
             </pgterms:ebook>
           </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects only unique entries" do
          expect(rdf.covers.count).to be 2
        end
        it "should convert File URIs to the Gutenberg URL" do
          expect(rdf.covers.first).to match 'http://www.gutenberg.org'
        end
        it "expects the covers to be listed in the correct order" do
          expect(rdf.covers[0]).to eql 'http://www.gutenberg.org/files/12345/12345-h/images/cover.jpg'
          expect(rdf.covers[1]).to eql 'http://www.gutenberg.org/files/12345/12345-rst/images/cover.jpg'
        end
      end
    end

    describe "#ebook" do
      let(:xml) do
        '<rdf:RDF xmlns:dcam="http://purl.org/dc/dcam/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:ebook rdf:about="ebooks/98765">
            <dcterms:hasFormat rdf:resource="http://www.gutenberg.org/ebooks/98765.txt.utf-8"/>
            <dcterms:hasFormat rdf:resource="http://www.gutenberg.org/ebooks/98765.zip"/>
          </pgterms:ebook>
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
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "expects the correct number of entries" do
        expect(rdf.ebooks.count).to be 2
      end
      it "expects an entry to be a Media class" do
        expect(rdf.ebooks.first.class).to be Rdf::Media
      end
    end
  end
end
