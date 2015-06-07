require 'spec_helper'

module GutenbergRdf
  class Rdf
    RSpec.describe Agent do
      let(:xml) do
        '<rdf:RDF xml:base="http://www.gutenberg.org/" xmlns:cc="http://web.resource.org/cc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcam="http://purl.org/dc/dcam/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:marcrel="http://id.loc.gov/vocabulary/relators/">
           <pgterms:ebook rdf:about="ebooks/99999999">
             <dcterms:creator>
               <pgterms:agent rdf:about="2009/agents/402">
                 <pgterms:deathdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1905</pgterms:deathdate>
                 <pgterms:birthdate rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">1830</pgterms:birthdate>
                 <pgterms:name>Doe, Jon James</pgterms:name>
                 <pgterms:alias>Doe, Jon</pgterms:alias>
                 <pgterms:alias>Doe, J. J.</pgterms:alias>
                 <pgterms:webpage rdf:resource="http://en.wikipedia.org/wiki/Jon_James_Doe"/>
               </pgterms:agent>
             </dcterms:creator>
           </pgterms:ebook>
         </rdf:RDF>'
      end
      let(:agent) do
        Agent.new(REXML::Document.new(xml).root.elements['pgterms:ebook/dcterms:creator/pgterms:agent'])
      end

      it "expects an agent ID" do
        expect(agent.id).to eq '402'
      end

      it "sets a default role" do
        expect(agent.role).to eq 'oth'
      end

      it "expects the last name" do
        expect(agent.lastname).to eq 'Doe'
      end

      it "expects the first name(s)" do
        expect(agent.firstname).to eq 'Jon James'
      end

      it "expects the full name" do
        expect(agent.fullname).to eq 'Jon James Doe'
      end

      it "returns the #fullname when to_s is called" do
        expect(agent.to_s).to eq 'Jon James Doe'
      end

      it "expects a birth date" do
        expect(agent.birthdate).to eq '1830'
      end

      it "expects a death date" do
        expect(agent.deathdate).to eq '1905'
      end

      it "expects a webpage" do
        expect(agent.webpage).to eq 'http://en.wikipedia.org/wiki/Jon_James_Doe'
      end

      it "expects any alias names" do
        expect(agent.aliases[0]).to eq 'Doe, Jon'
        expect(agent.aliases[1]).to eq 'Doe, J. J.'
      end

      context "when only a single name is given" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent rdf:about="2009/agents/402">
                     <pgterms:name>Dato</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          Agent.new(REXML::Document.new(xml).root.elements['pgterms:agent'])
        end

        it "expects it to be assigned to the last name" do
          expect(agent.lastname).to eq 'Dato'
        end
        it "expects firstname to be an empty string" do
          expect(agent.firstname).to eq ''
        end
      end

      context "when the name has a suffix" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent rdf:about="2009/agents/402">
                     <pgterms:name>Doe, Jon, Sir</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          Agent.new(REXML::Document.new(xml).root.elements['pgterms:agent'])
        end

        it "expects the correct name order" do
          expect(agent.firstname).to eq 'Sir Jon'
          expect(agent.lastname).to eq 'Doe'
        end
      end

      context "when full name is given in (brackets)" do
        let(:agent) do
          xml = '<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:pgterms="http://www.gutenberg.org/2009/pgterms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                   <pgterms:agent agent:about="2009/agents/402">
                     <pgterms:name>Doe, J. J. (Jon James)</pgterms:name>
                   </pgterms:agent>
                 </rdf:RDF>'
          Agent.new(REXML::Document.new(xml).root.elements['pgterms:agent'])
        end

        it "expects initials to replaced by name in brackets" do
          pending "Not yet implemented"
          expect(agent.firstname).to eq 'Jon James'
          expect(agent.lastname).to eq 'Doe'
        end
        it "expects the name (excluding name in brackets) to be added to the aliases"
        it "should not have duplicate aliases"
      end
    end

  end
end
