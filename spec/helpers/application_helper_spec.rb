require "spec_helper"

describe ApplicationHelper do
  describe "num_weeks" do
    it "returns number of weeks between two dates" do
      # helper.page_title.should be_true
      helper.num_weeks(Date.today - 14, Date.today).should eql(2.0)
    end

    it "returns number of weeks between dates that cross the year" do
      # helper.page_title.should be_true
      helper.num_weeks(Date.new(2013,12,30), Date.new(2014, 01, 6)).should eql(1.0)
    end

    it "returns number of weeks between an end date and Today" do
      # helper.page_title.should be_true
      helper.num_weeks(Date.today - 14, nil).should eql(2.0)
    end

    it "returns empty if no dates are specified" do
      # helper.page_title.should be_true
      helper.num_weeks(nil, nil).should eql(0)
    end
  end

  describe "nearing_deadline" do
    it "if deadline was 2 days ago" do
      helper.nearing_deadline(Date.today - 6).should be_true
    end

    it "if deadline was 45 days ago" do
      helper.nearing_deadline(Date.today - 45).should be_true
    end

    it "if deadline is in 5 days" do
      helper.nearing_deadline(Date.today + 5).should be_true
    end
  end
end