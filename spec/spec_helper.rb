require 'vatbook'

module Vatbook
  class BookFetcher
    def raw_list
      Nokogiri::XML(open("spec/xml2.xml"))
    end
  end
end
