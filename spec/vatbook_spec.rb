require 'spec_helper.rb'

describe String do

  describe "fir" do
    it "should work :)" do
      "LQSB".vatbook.count.should eq(207)
    end

    it "should contain attributes" do
      "LQSB".vatbook.first.role.should eq("atc")
      "LQSB".vatbook.first.callsign.should eq("LFMN_TWR")
      "LQSB".vatbook.first.name.should eq("Tomba Quentin")
      "LQSB".vatbook.first.cid.should eq("1227003")
      "LQSB".vatbook.first.start.should eq("2012-10-08 08:00:00")
      "LQSB".vatbook.first.end.should eq("2012-10-08 10:00:00")
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
      Vatbook::BookFetcher.new(icao).pilots_count.should eq(1)
    end
  end
end
