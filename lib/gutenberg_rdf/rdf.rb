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

    def authors
      @authors ||= extract_authors
    end

    def subjects
      entries = Array.new
      xml.xpath('pgterms:ebook//dcterms:subject').each do |entry|
        next unless entry.at_xpath('rdf:Description/dcam:memberOf').attribute('resource').text.match(/LCSH\z/)
        entry.xpath('rdf:Description//rdf:value').each do |value|
          entries << value.text
        end
      end
      entries
    end

    def published
      xml.at_xpath('pgterms:ebook/dcterms:issued').text
    end

    def publisher
      xml.at_xpath('pgterms:ebook/dcterms:publisher').text
    end

    def language
      xml.at_xpath('pgterms:ebook/dcterms:language').text
    end

    def rights
      xml.at_xpath('pgterms:ebook/dcterms:rights').text
    end

    def covers
      official_cover_images.concat(other_cover_images).sort.uniq
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

    def extract_authors
      entries = Array.new
      xml.xpath('//pgterms:agent').each do |agent|
        entries << Agent.new(agent)
      end
      entries
    end

    def official_cover_images
      entries = Array.new
      xml.xpath('//pgterms:file').each do |file|
        url = file.attribute('about').content
        entries << url if file.xpath('dcterms:format/rdf:Description//rdf:value').detect { |v| v.text.match(/image/) }
      end
      entries
    end

    def other_cover_images
      entries = Array.new
      xml.xpath('pgterms:ebook//pgterms:marc901').each do |node|
        cover = node.text
        cover.sub!(/\Afile:\/\/\/public\/vhost\/g\/gutenberg\/html/, 'http://www.gutenberg.org')
        entries << cover
      end
      entries
    end

  end
end
