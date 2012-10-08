require "vatbook/version"

class String
  def vatbook(args={})
    Vatbook.bookings(self, args)
  end
end

module Vatbook
  def self.bookings(fir, args)
    BookFetcher.new(fir, args).fetch
  end

  class BookFetcher
    require 'nokogiri'
    require 'open-uri'

    attr_accessor :fir, :atc_bookings, :pilot_bookings, :enroute, :doc

    def initialize(fir, args = nil)
      @fir = fir
      process_arguments(args) if args.class == Hash
      @atc_bookings = []; @pilot_bookings = [];
      @doc = raw_list
      atcs
    end

    def raw_list
      # Nokogiri::XML(open("http://vatbook.euroutepro.com/xml2.php?fir=#{@fir}"))
      Nokogiri::XML(open("spec/xml2.xml")) # used in testing
    end

    def fetch
      @atc_bookings
    end

    def atcs_count
      @doc.css("atcs booking").count
    end

    def pilots_count
      @doc.css("pilots booking").count
    end

    private

    def atcs
      @doc.css("atcs booking").each do |booking|
        @atc_bookings << Booking.new(booking, role = "atc")
      end
      # @doc.css("atcs booking").first.children.css("callsign").first.children.to_s
    end

    def pilots
      @doc.css("pilots booking").each do |booking|
        @pilot_bookings << Booking.new(booking, role = "pilot")
      end
    end

    def process_arguments(args)
      args[:enroute] == true ? @enroute = true : @enroute = false
    end

  end

   class Booking
    require 'nokogiri'

    attr_accessor :role, :callsign, :name, :cid, :start, :end, :dep, :arr
    attr_accessor :aircraft, :route


    def initialize(booking, role)
      @role = role
      @callsign = booking.children.css("callsign").first.children.to_s
      @name = booking.children.css("name").first.children.to_s
      @role == "atc" ? @cid = booking.children.css("cid").first.children.to_s : @cid = booking.children.css("pid").first.children.to_s
      if @role == "atc"
        @start = booking.children.css("time_start").first.children.to_s
        @end = booking.children.css("time_end").first.children.to_s
      elsif @role == "pilot"
        @dep = booking.children.css("dep").first.children.to_s
        @arr = booking.children.css("arr").first.children.to_s
        @route = booking.children.css("route").first.children.to_s
        @start = booking.children.css("from").first.children.to_s
        @end = booking.children.css("to").first.children.to_s
        @aircraft = booking.children.css("actype").first.children.to_s
      end
    end

  end


end
