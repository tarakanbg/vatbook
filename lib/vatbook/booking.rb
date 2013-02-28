module Vatbook

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