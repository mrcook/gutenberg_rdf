require 'date'

module GutenbergRdf
  class Rdf
    attr_reader :xml

    def initialize(xml)
      @xml = xml.root
    end

    def id
      xml.elements['pgterms:ebook'].attributes['about'].match(/\Aebooks\/(.+)\z/)[1]
    end

    def type
      xml.elements['pgterms:ebook/dcterms:type/rdf:Description/rdf:value'].text
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
      xml.elements.each('pgterms:ebook/dcterms:subject') do |entry|
        next unless entry.elements['rdf:Description/dcam:memberOf'].attributes['resource'].match(/LCSH\z/)
        entry.elements.each('rdf:Description//rdf:value') do |value|
          entries << value.text
        end
      end
      entries
    end

    def published
      xml.elements['pgterms:ebook/dcterms:issued'].text
    end

    def publisher
      xml.elements['pgterms:ebook/dcterms:publisher'].text
    end

    def language
      xml.elements['pgterms:ebook/dcterms:language'].text
    end

    def rights
      xml.elements['pgterms:ebook/dcterms:rights'].text
    end

    def covers
      official_cover_images.concat(other_cover_images).sort.uniq
    end

    def ebooks
      files = Array.new
      xml.elements.each('pgterms:file') do |file|
        files << Media.new(file)
      end
      files
    end

  private

    def titles
      @titles ||= split_title_and_subtitle
    end

    def split_title_and_subtitle
      # NOTE: this gsub is replacing UTF-8 hyphens with normal ASCII ones
      t = xml.elements['pgterms:ebook/dcterms:title'].text.gsub(/—/, '-')

      title_array = t.split(/\n/)
      title_array = title_array.first.split(/:/) if title_array.count == 1
      title_array = title_array.first.split(/;/) if title_array.count == 1
      title_array = title_array.first.split(/, or,/) if title_array.count == 1

      title_array.map(&:strip)
    end

    def extract_authors
      entries = Array.new
      xml.elements.each('pgterms:agent') do |agent|
        entries << Agent.new(agent)
      end
      entries
    end

    def official_cover_images
      entries = Array.new
      xml.elements.each('pgterms:file') do |file|
        entries << file.attributes['about'] if file_is_image?(file)
      end
      entries
    end

    def file_is_image?(node)
      node.elements.each('dcterms:format/rdf:Description/rdf:value') do |value|
        return true if value.text.match(/image/)
      end
      false
    end

    def other_cover_images
      entries = Array.new
      xml.elements.each('pgterms:ebook/pgterms:marc901') do |node|
        cover = node.text
        cover.sub!(/\Afile:\/\/\/public\/vhost\/g\/gutenberg\/html/, 'http://www.gutenberg.org')
        entries << cover
      end
      entries
    end

  end
end
