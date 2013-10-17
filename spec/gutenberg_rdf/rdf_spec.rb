require 'spec_helper'

module GutenbergRdf
  describe Rdf do
    it "expects an id" do
      xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
               <pgterms:ebook rdf:about="ebooks/19399">
                 </pgterms:ebook>
             </rdf:RDF>'
      rdf = Rdf.new(Nokogiri::XML(xml))
      expect(rdf.id).to eql "19399"
    end

    describe "Titles" do
      let(:xml) do
        '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
           <pgterms:ebook rdf:about="ebooks/19399">
             <dcterms:title>A Great Title</dcterms:title>
           </pgterms:ebook>
         </rdf:RDF>'
      end
      it "expects a title" do
        rdf = Rdf.new(Nokogiri::XML(xml))
        expect(rdf.title).to eql 'A Great Title'
      end
      it "expects subtitle to be empty" do
        rdf = Rdf.new(Nokogiri::XML(xml))
        expect(rdf.subtitle).to eql ''
      end

      context "with a title and subtitle, on separate lines" do
        let(:xml) do
          '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/19399">
              <dcterms:title>A Great Multi-Title
                Or, a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(Nokogiri::XML(xml)) }

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
            <pgterms:ebook rdf:about="ebooks/19399">
              <dcterms:title>A Great Multi-Title: And a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(Nokogiri::XML(xml)) }

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
            <pgterms:ebook rdf:about="ebooks/19399">
              <dcterms:title>A Great Multi-Title; Or, a Subtitle</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
        end
        let(:rdf) { Rdf.new(Nokogiri::XML(xml)) }
        it "expects a title" do
          expect(rdf.title).to eql 'A Great Multi-Title'
        end
        it "expects a subtitle" do
          expect(rdf.subtitle).to eql 'Or, a Subtitle'
        end

        context "...except when subtitles already exists" do
          let(:xml) do
            '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <pgterms:ebook rdf:about="ebooks/19399">
              <dcterms:title>A Great Multi-Title; and some other text
                Then a Subtitle on a newline</dcterms:title>
            </pgterms:ebook>
          </rdf:RDF>'
          end
          let(:rdf) { Rdf.new(Nokogiri::XML(xml)) }
          it "expects a title" do
            expect(rdf.title).to eql 'A Great Multi-Title; and some other text'
          end
          it "expects a subtitle" do
            expect(rdf.subtitle).to eql 'Then a Subtitle on a newline'
          end
        end
      end
    end

  end
end
