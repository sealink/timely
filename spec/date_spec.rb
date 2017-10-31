require 'spec_helper'

describe Date do
  it 'should determine if date between' do
    expect(Date.today.between?(nil, nil)).to be true
    expect(Date.today.between?(Date.today - 1, Date.today - 1)).to be false
    expect(Date.today.between?(Date.today - 1, nil)).to be true
  end
end

describe Date do
  before :each do
    @date = Date.today - 5
    Time.zone = 'Australia/Eucla'

    @hour   = 1
    @minute = 2
    @second = 3
  end

  it 'should give a time on that date' do
    expect(@date).to respond_to(:at_time)
  end

  describe 'giving a time on that date' do
    it 'should accept hour, minute, and second' do
      expect { @date.at_time(@hour, @minute, @second) }.to_not raise_error
    end

    it 'should accept hour and minute' do
      expect { @date.at_time(@hour, @minute) }.to_not raise_error
    end

    it 'should accept hour' do
      expect { @date.at_time(@hour) }.to_not raise_error
    end

    it 'should accept no arguments' do
      expect { @date.at_time }.to_not raise_error
    end

    it 'should return a time for the given hour, minute, and second if all three are specified' do
      expected = Time.zone.local(@date.year, @date.month, @date.day, @hour, @minute, @second)
      expect(@date.at_time(@hour, @minute, @second)).to eq expected
    end

    it 'should default second to 0 if unspecified' do
      expected = Time.zone.local(@date.year, @date.month, @date.day, @hour, @minute, 0)
      expect(@date.at_time(@hour, @minute)).to eq expected
    end

    it 'should default minute to 0 if unspecified' do
      expected = Time.zone.local(@date.year, @date.month, @date.day, @hour, 0, 0)
      expect(@date.at_time(@hour)).to eq expected
    end

    it 'should default hour to 0 if unspecified' do
      expected = Time.zone.local(@date.year, @date.month, @date.day, 0, 0, 0)
      expect(@date.at_time).to eq expected
    end

    it 'should accept a time' do
      expect { @date.at_time(Time.now) }.to_not raise_error
    end

    it 'should return the passed-in time on the date' do
      @time = Time.now - 12345
      expected = Time.zone.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
      expect(@date.at_time(@time)).to eq expected
    end
  end

  # at is only alias for non time zone override (e.g. non rails)
  context "using at alias" do
    it "should accept hour, minute, second" do
      expected = Time.local(@date.year, @date.month, @date.day, @hour, @minute, @second)
      expect(@date.at(@hour, @minute, @second)).to eq expected
    end

    it "should accept time" do
      @time = Time.now - 12345
      expected = Time.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
      expect(@date.at(@time)).to eq expected
    end
  end
end
