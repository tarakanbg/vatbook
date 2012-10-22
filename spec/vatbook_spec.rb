require 'spec_helper.rb'

describe String do

  describe "fir" do
    it "should work :)" do
      "LQSB".vatbook.count.should eq(2)
      "LQSB".vatbook[:atc].count.should eq(207)
      "LQSB".vatbook[:pilots].count.should eq(2)
      "lqsb".vatbook[:atc].count.should eq(207)
      "lqsb".vatbook[:pilots].count.should eq(2)
    end

    it "should contain attributes" do
      "LQSB".vatbook[:atc].first.role.should eq("atc")
      "LQSB".vatbook[:atc].first.callsign.should eq("LFMN_TWR")
      "LQSB".vatbook[:atc].first.name.should eq("Tomba Quentin")
      "LQSB".vatbook[:atc].first.cid.should eq("1227003")
      "LQSB".vatbook[:atc].first.start.should eq("2012-10-08 08:00:00")
      "LQSB".vatbook[:atc].first.end.should eq("2012-10-08 10:00:00")
      "LQSB".vatbook[:pilots].first.role.should eq("pilot")
      "LQSB".vatbook[:pilots].first.callsign.should eq("KLM112")
    end
  end

end

describe Vatbook do

  describe "vatsim_online" do
    it "should work :)" do
    end
  end

end


describe Vatbook::BookFetcher do
  describe "atcs count" do
    it "should return correct count" do
      icao = "LQSB"
      Vatbook::BookFetcher.new(icao).atcs_count.should eq(207)
      Vatbook::BookFetcher.new(icao).pilots_count.should eq(2)
    end
  end

  describe "pilot bookings" do
    it "should parse pilot attributes" do
      icao = "LQSB"
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.role.should eq("pilot")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.callsign.should eq("KLM112")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.name.should eq("Edwin Middelaar EHAM")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.cid.should eq("931960")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.route.should eq("OTREX UM872 PLH UB1 DDM UM619 YNN UL604 BIGGE T281 NORKU")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.dep.should eq("LGIR")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.arr.should eq("EHAM")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.aircraft.should eq("B738")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.fir.should eq("LQSB")
      Vatbook::BookFetcher.new(icao).pilot_bookings.first.enroute.should eq(true)
    end

    it "should identify enroutes" do
      icao = "LQSB"
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.role.should eq("pilot")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.callsign.should eq("KLM113")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.name.should eq("Edwin Middelaar EHAM")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.cid.should eq("931960")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.route.should eq("OTREX UM872 PLH UB1 DDM UM619 YNN UL604 BIGGE T281 NORKU")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.dep.should eq("LGIR")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.arr.should eq("LQSA")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.aircraft.should eq("B738")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.fir.should eq("LQSB")
      Vatbook::BookFetcher.new(icao).pilot_bookings.last.enroute.should eq(false)
    end

    it "should handle enroute hash options" do
      icao = "LQSB"
      args = {:enroute => true}
      Vatbook::BookFetcher.new(icao, args).pilot_bookings.count.should eq(2)
      Vatbook::BookFetcher.new(icao, args).pilot_bookings.first.arr.should eq("EHAM")
      args = {:enroute => false}
      Vatbook::BookFetcher.new(icao, args).pilot_bookings.count.should eq(1)
      Vatbook::BookFetcher.new(icao, args).pilot_bookings.first.arr.should eq("LQSA")
    end
  end

  describe "atc bookings" do
    it "should parse atc attributes" do
      icao = "LQSB"
      Vatbook::BookFetcher.new(icao).atc_bookings.first.role.should eq("atc")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.fir.should eq("LQSB")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.callsign.should eq("LFMN_TWR")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.name.should eq("Tomba Quentin")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.cid.should eq("1227003")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.start.should eq("2012-10-08 08:00:00")
      Vatbook::BookFetcher.new(icao).atc_bookings.first.end.should eq("2012-10-08 10:00:00")
    end
  end
end
