module GutenbergRdf
  class Rdf
    class Agent
      attr_reader :xml
      attr_accessor :role

      def initialize(xml)
        @xml = xml
      end

      def to_s
        fullname
      end

      def id
        xml.attributes['about'].match(/\A\d\d\d\d\/agents\/(\d+)\z/)[1]
      end

      def role
        @role ||= 'oth'
      end

      def assign_role(roles)
        self.role = roles["#{id}"]
      end

      def fullname
        [firstname, lastname].reject(&:empty?).join(' ')
      end

      def lastname
        @lastname ||= name_parts[:last]
      end

      def firstname
        @firstname ||= name_parts[:first]
      end

      def birthdate
        xml.elements['pgterms:birthdate'].text
      end

      def deathdate
        xml.elements['pgterms:deathdate'].text
      end

      def webpage
        xml.elements['pgterms:webpage'].attributes['resource']
      end

      def aliases
        entries = Array.new
        xml.elements.each('pgterms:alias') do |name|
          entries << name.text
        end
        entries
      end

    private

      def name_parts
        parts = xml.elements['pgterms:name'].text.split(/, */)
        last  = parts.shift
        first = parts.reverse.join(' ')

        {first: first, last: last}
      end

    end
  end
end
