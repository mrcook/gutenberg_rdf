module GutenbergRdf
  class Rdf
    attr_reader :xml

    def initialize(xml)
      @xml = xml.at_xpath('rdf:RDF')
    end

    def id
      xml.at_xpath('pgterms:ebook').attribute('about').content.match(/\Aebooks\/(.+)\z/)[1]
    end

    def title
      titles.first
    end

    def subtitle
      titles[1..-1].join(' - ')
    end

  private

    def titles
      @titles ||= split_title_and_subtitle
    end

    def split_title_and_subtitle
      # Note this gsub is replacing UTF-8 hyphens with normal ASCII ones
      t = xml.at_xpath('pgterms:ebook/dcterms:title').text.gsub(/—/, '-')

      title_array = t.split(/\n/)
      title_array = title_array.first.split(/:/) if title_array.count == 1
      title_array = title_array.first.split(/;/) if title_array.count == 1

      title_array.each(&:strip!)
    end

  end
end
