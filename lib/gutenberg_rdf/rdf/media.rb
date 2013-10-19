module GutenbergRdf
  class Rdf
    class Media
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def uri
        xml.attributes['about']
      end

      def media_type
        datatype[:type]
      end

      def encoding
        datatype[:encoding]
      end

      def modified
        DateTime.parse(xml.elements['dcterms:modified'].text + '-07:00')
      end

    private

      def datatype
        parts = xml.elements['dcterms:format/rdf:Description/rdf:value'].text.split(/; */)
        t = parts.shift
        e = parts.join(';').sub('charset=', '')
        {type: t, encoding: e}
      end

    end
  end
end
