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
        expect(agent.last_name).to eql 'Doe'
      end

      it "expects the first name(s)" do
        expect(agent.first_name).to eql 'Jon James'
      end

    end
  end
end
