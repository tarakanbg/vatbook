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
      @fir = fir.upcase
      @enroute = true
      process_arguments(args) if args.class == Hash
      @atc_bookings = []; @pilot_bookings = [];
      @doc = raw_list
      atcs
      pilots
    end

    def raw_list
      Nokogiri::XML(open("http://vatbook.euroutepro.com/xml2.php?fir=#{@fir}"))
    end

    def fetch
       {:atc => atc_bookings, :pilots => pilot_bookings}
    end

    def atc_bookings
      @atc_bookings
    end

    def pilot_bookings
      @pilot_bookings
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
        @atc_bookings << Booking.new(booking, role = "atc", @fir)
      end
    end

    def pilots
      @doc.css("pilots booking").each do |booking|
        if @enroute == false
          bk = Booking.new(booking, role = "pilot", @fir)
          if bk.enroute == false
            @pilot_bookings << bk
          end
        else
          @pilot_bookings << Booking.new(booking, role = "pilot", @fir)
        end
      end
    end

    def process_arguments(args)
      args[:enroute] == false ? @enroute = false : @enroute = true
    end

  end

   class Booking
    require 'nokogiri'

    attr_accessor :role, :callsign, :name, :cid, :start, :end, :dep, :arr
    attr_accessor :aircraft, :route, :enroute, :fir


    def initialize(booking, role, fir)
      @fir = fir
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
        @route = booking.children.css("route").first.children.to_s.gsub(/[\n]/, ' ').strip
        @start = booking.children.css("from").first.children.to_s
        @end = booking.children.css("to").first.children.to_s
        @aircraft = booking.children.css("actype").first.children.to_s
        check_enroute
      end
    end

  private
    def check_enroute
      if @fir[0..1] == @dep[0..1] or @fir[0..1] == @arr[0..1]
        @enroute = false
      else
        @enroute = true
      end
    end

  end

end
