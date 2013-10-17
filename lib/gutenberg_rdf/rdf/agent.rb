module GutenbergRdf
  class Rdf
    class Agent
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def id
        xml.at_xpath('pgterms:agent').attribute('about').content.match(/\A\d\d\d\d\/agents\/(\d+)\z/)[1]
      end

      def last_name
        xml.at_xpath('pgterms:agent/pgterms:name').text.split(/, */).first
      end

      def first_name
        xml.at_xpath('pgterms:agent/pgterms:name').text.split(/, */).last
      end

    end
  end
end
