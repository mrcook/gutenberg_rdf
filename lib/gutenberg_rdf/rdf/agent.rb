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

      def fullname
        [firstname, lastname].join(' ')
      end

      def lastname
        @lastname ||= name_parts[:last]
      end

      def firstname
        @firstname ||= name_parts[:first]
      end

      def birthdate
        xml.at_xpath('pgterms:agent/pgterms:birthdate').text
      end

      def deathdate
        xml.at_xpath('pgterms:agent/pgterms:deathdate').text
      end

      def webpage
        xml.at_xpath('pgterms:agent/pgterms:webpage').attribute('resource').content
      end

      def aliases
        entries = Array.new
        xml.xpath('//pgterms:alias').each do |name|
          entries << name.text
        end
        entries
      end

    private

      def name_parts
        parts = xml.xpath('//pgterms:name').text.split(/, */)
        last  = parts.shift
        first = parts.reverse.join(' ')

        {first: first, last: last}
      end

    end
  end
end
