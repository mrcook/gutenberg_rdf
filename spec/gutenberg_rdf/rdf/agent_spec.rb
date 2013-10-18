require 'spec_helper'

module GutenbergRdf
  class Rdf
    describe Agent do
      let(:agent) do
        xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <pgterms:agent rdf:about="2009/agents/402">
                  <pgterms:birthdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1830</pgterms:birthdate>
                  <pgterms:deathdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1905</pgterms:deathdate>
                  <pgterms:name>Doe, Jon James</pgterms:name>
                  <pgterms:alias>Doe, Jon</pgterms:alias>
                  <pgterms:alias>Doe, J. J.</pgterms:alias>
                  <pgterms:webpage rdf:resource="http://en.wikipedia.org/wiki/Jon_James_Doe"/>
                </pgterms:agent>
              </rdf:RDF>'
        rdf = Nokogiri::XML(xml)
        Agent.new(rdf.at_xpath('rdf:RDF'))
      end

      it "expects an agent ID" do
        expect(agent.id).to eql '402'
      end

      it "expects the last name" do
        expect(agent.lastname).to eql 'Doe'
      end

      it "expects the first name(s)" do
        expect(agent.firstname).to eql 'Jon James'
      end

      it "expects the full name" do
        expect(agent.fullname).to eql 'Jon James Doe'
      end

      it "expects a birth date" do
        expect(agent.birthdate).to eql '1830'
      end

      it "expects a death date" do
        expect(agent.deathdate).to eql '1905'
      end

      it "expects a webpage" do
        expect(agent.webpage).to eql 'http://en.wikipedia.org/wiki/Jon_James_Doe'
      end

      it "expects any alias names" do
        expect(agent.aliases[0]).to eql 'Doe, Jon'
        expect(agent.aliases[1]).to eql 'Doe, J. J.'
      end

      context "when only a single name is given" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent rdf:about="2009/agents/402">
                     <pgterms:name>Dato</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          rdf = Nokogiri::XML(xml)
          Agent.new(rdf.at_xpath('rdf:RDF'))
        end

        it "expects it to be assigned to the last name" do
          expect(agent.lastname).to eql 'Dato'
        end
        it "expects firstname to be an empty string" do
          expect(agent.firstname).to eql ''
        end
      end

      context "when the name has a suffix" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent rdf:about="2009/agents/402">
                     <pgterms:name>Doe, Jon, Sir</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          rdf = Nokogiri::XML(xml)
          Agent.new(rdf.at_xpath('rdf:RDF'))
        end

        it "expects the correct name order" do
          expect(agent.firstname).to eql 'Sir Jon'
          expect(agent.lastname).to eql 'Doe'
        end
      end

      context "when full name is given in (brackets)" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent agent:about="2009/agents/402">
                     <pgterms:name>Doe, J. J. (Jon James)</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          rdf = Nokogiri::XML(xml)
          Agent.new(rdf.at_xpath('rdf:RDF'))
        end

        it "expects initials to replaced by name in brackets" do
          pending "this functionality needs implementing"
          expect(agent.firstname).to eql 'Jon James'
          expect(agent.lastname).to eql 'Doe'
        end
        it "expects the name (excluding name in brackets) to be added to the aliases"
        it "should not have duplicate aliases"
      end
    end

  end
end
