require 'spec_helper'

module GutenbergRdf
  describe Rdf do

    describe "basic metadata" do
      let(:xml) do
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2006-09-28</dcterms:issued>
             <dcterms:language>
               <rdf:Description rdf:nodeID="N88989dfs7984987df987cvcsd876ew79">
                 <rdf:value rdf:datatype="http://purl.org/dc/terms/RFC4646">en</rdf:value>
               </rdf:Description>
             </dcterms:language>
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
    end

    describe "#type" do
      let(:xml) do
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:type>
               <rdf:Description rdf:nodeID="Nd89943yhljdsf93489ydfs897g7fd897">
                 <rdf:value>Text</rdf:value>
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/DCMIType"/>
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
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
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
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
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

      context "with; title, or, subtitle (we need to split on the 'or')" do
        let(:xml) do
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/98765">
              <dcterms:title>A Great Multi-Title, or, a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects the title to be the first line" do
          expect(rdf.title).to eql 'A Great Multi-Title'
        end
        it "expects the subtitle to be the second line" do
          expect(rdf.subtitle).to eql 'a Subtitle'
        end
      end

      context "when title:subtitle are separated by a colon" do
        let(:xml) do
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
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
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
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
            '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
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
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:marcrel="http://id.loc.gov/vocabulary/relators/">
          <pgterms:ebook rdf:about="ebooks/99999999">
            <dcterms:creator>
              <pgterms:agent rdf:about="2009/agents/116">
                <pgterms:alias>Verschillende</pgterms:alias>
                <pgterms:name>Various</pgterms:name>
              </pgterms:agent>
            </dcterms:creator>
            <marcrel:ctb>
              <pgterms:agent rdf:about="2009/agents/402">
                <pgterms:deathdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1830</pgterms:deathdate>
                <pgterms:birthdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1905</pgterms:birthdate>
                <pgterms:name>Dodge, Mary Mapes</pgterms:name>
                <pgterms:alias>Dodge, Mary</pgterms:alias>
                <pgterms:webpage rdf:resource="http://en.wikipedia.org/wiki/Mary_Mapes_Dodge"/>
              </pgterms:agent>
            </marcrel:ctb>
          </pgterms:ebook>
        </rdf:RDF>'
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "returns the correct number of authors" do
        expect(rdf.authors.count).to be 2
      end
      it "expects an Agent object" do
        expect(rdf.authors[0]).to be_an_instance_of Rdf::Agent
      end
      it "expects the author to have an aut role" do
        expect(rdf.authors[0].role).to eq 'aut'
      end
      it "has the correct author names" do
        expect(rdf.authors[1].fullname).to eq 'Mary Mapes Dodge'
      end
      it "expects other agents to have the correct role" do
        expect(rdf.authors[1].role).to eq 'ctb'
      end
    end

    describe "#subjects" do
      let(:xml) do
        %q{<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/98765">
             <dcterms:subject>
               <rdf:Description rdf:nodeID="Ndfsc8xdsfwar734897n7sdofyhod11b9">
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/LCC"/>
                 <rdf:value>PZ</rdf:value>
               </rdf:Description>
             </dcterms:subject>
             <dcterms:subject>
               <rdf:Description rdf:nodeID="Ndfcdh8934hsdljkfh98y89hlfhltyab8">
                 <dcam:memberOf rdf:resource="http://purl.org/dc/terms/LCSH"/>
                 <rdf:value>Children's literature -- Periodicals</rdf:value>
                 <rdf:value>Children's periodicals, American</rdf:value>
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
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
             <pgterms:ebook rdf:about="ebooks/98765">
               <dcterms:hasFormat>
                 <pgterms:file rdf:about="http://www.gutenberg.org/cache/epub/98765/pg98765.cover.small.jpg">
                   <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">2699</dcterms:extent>
                   <dcterms:format>
                     <rdf:Description rdf:nodeID="N9u34589eyfdiuy8934y787d8f97sg786">
                       <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                       <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">image/jpeg</rdf:value>
                     </rdf:Description>
                   </dcterms:format>
                   <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                   <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-03-25T20:57:55.668737</dcterms:modified>
                 </pgterms:file>
               </dcterms:hasFormat>
               <pgterms:marc901>http://www.gutenberg.org/files/98765/98765-h/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/98765/98765-h/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/98765/98765-rst/images/cover.jpg</pgterms:marc901>
               <dcterms:hasFormat>
                 <pgterms:file rdf:about="http://www.gutenberg.org/cache/epub/98765/pg98765.cover.medium.jpg">
                   <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-03-25T20:57:55.889736</dcterms:modified>
                   <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                   <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">10856</dcterms:extent>
                   <dcterms:format>
                     <rdf:Description rdf:nodeID="N8df89ys8993p4qu89uenf89dusp38a07">
                       <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                       <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">image/jpeg</rdf:value>
                     </rdf:Description>
                   </dcterms:format>
                 </pgterms:file>
               </dcterms:hasFormat>
             </pgterms:ebook>
           </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "expects the correct number of entries returned" do
          expect(rdf.covers.count).to be 4
        end
        it "expect medium cover url to be first in the list" do
          expect(rdf.covers[0]).to eql 'http://www.gutenberg.org/cache/epub/98765/pg98765.cover.medium.jpg'
        end
        it "expect the small cover url after the medium" do
          expect(rdf.covers[1]).to eql 'http://www.gutenberg.org/cache/epub/98765/pg98765.cover.small.jpg'
        end
        it "expects any other images to be listed after the official ones" do
          expect(rdf.covers[2]).to eql 'http://www.gutenberg.org/files/98765/98765-h/images/cover.jpg'
        end
      end

      describe "HTML ebook cover image" do
        let(:xml) do
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
             <pgterms:ebook rdf:about="ebooks/98765">
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/98765/98765-rst/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>file:///public/vhost/g/gutenberg/html/files/98765/98765-h/images/cover.jpg</pgterms:marc901>
               <pgterms:marc901>http://www.gutenberg.org/files/98765/98765-h/images/cover.jpg</pgterms:marc901>
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
        it "expects the HTML cover to be listed first" do
          expect(rdf.covers[0]).to eql 'http://www.gutenberg.org/files/98765/98765-h/images/cover.jpg'
        end
        it "expects the RST cover to be listed after the HTML" do
          expect(rdf.covers[1]).to eql 'http://www.gutenberg.org/files/98765/98765-rst/images/cover.jpg'
        end
      end
    end

    describe "#ebook" do
      let(:xml) do
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:ebook rdf:about="ebooks/98765">
            <dcterms:hasFormat>
              <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/98765.txt.utf-8">
                <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">293684</dcterms:extent>
                <dcterms:format>
                  <rdf:Description rdf:nodeID="N87dfy78yd78s6gsg6f8970d76g0f6d9b">
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain</rdf:value>
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2010-02-16T08:29:52.373092</dcterms:modified>
              </pgterms:file>
            </dcterms:hasFormat>
            <dcterms:hasFormat>
              <pgterms:file rdf:about="http://www.gutenberg.org/files/98765/98765.zip">
                <dcterms:format>
                  <rdf:Description rdf:nodeID="Ndfsd78tf34tukjehdsouyo4yrefh6dea">
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">application/zip</rdf:value>
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2006-09-28T12:37:26</dcterms:modified>
                <dcterms:format>
                  <rdf:Description rdf:nodeID="Nfy7we43yhluwe9syrqyp2ewufy0f6d1e">
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain; charset=us-ascii</rdf:value>
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">116685</dcterms:extent>
              </pgterms:file>
            </dcterms:hasFormat>
          </pgterms:ebook>
        </rdf:RDF>'
      end
      let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

      it "expects the correct number of entries" do
        expect(rdf.ebooks.count).to be 2
      end
      it "expects an entry to be a Media class" do
        expect(rdf.ebooks.first).to be_an_instance_of Rdf::Media
      end

      context "only collect ebook media files" do
        let(:xml) do
          '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <pgterms:ebook rdf:about="ebooks/98765">
            <dcterms:hasFormat>
              <pgterms:file rdf:about="http://www.gutenberg.org/ebooks/98765.txt.utf-8">
                <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">293684</dcterms:extent>
                <dcterms:format>
                  <rdf:Description rdf:nodeID="N87dfy78yd78s6gsg6f8970d76g0f6d9b">
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">text/plain</rdf:value>
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2010-02-16T08:29:52.373092</dcterms:modified>
              </pgterms:file>
            </dcterms:hasFormat>
            <dcterms:hasFormat>
              <pgterms:file rdf:about="http://www.gutenberg.org/cache/epub/98765/pg98765.cover.small.jpg">
                <dcterms:extent rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">2699</dcterms:extent>
                <dcterms:format>
                  <rdf:Description rdf:nodeID="N9u34589eyfdiuy8934y787d8f97sg786">
                    <dcam:memberOf rdf:resource="http://purl.org/dc/terms/IMT"/>
                    <rdf:value rdf:datatype="http://purl.org/dc/terms/IMT">image/jpeg</rdf:value>
                  </rdf:Description>
                </dcterms:format>
                <dcterms:isFormatOf rdf:resource="ebooks/98765"/>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2013-03-25T20:57:55.668737</dcterms:modified>
              </pgterms:file>
            </dcterms:hasFormat>
          </pgterms:ebook>
        </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(REXML::Document.new(xml)) }

        it "only extracts one media file" do
          expect(rdf.ebooks.count).to be 1
        end
        it "expects the media type to be for an ebook" do
          expect(rdf.ebooks[0].media_type).to eq 'text/plain'
        end
      end
    end
  end
end
