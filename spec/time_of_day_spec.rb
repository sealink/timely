require 'spec_helper'

describe Timely::TimeOfDay do
  subject(:time_of_day) { Timely::TimeOfDay.new(4, 52) }

  before { allow(Timely::Date).to receive(:current) { Date.new(2014, 1, 1) } }

  its(:hour) { should == 4 }
  its(:minute) { should == 52 }
  its(:to_s) { should eq Time.zone.local(2014, 1, 1, 4, 52, 0).to_s }

  context 'asking for that time on a date' do
    subject(:time) { time_of_day.on_date(Date.new(2014, 1, 1)) }
    its(:month) { should == 1 }
    its(:hour) { should == 4 }
    its(:min) { should == 52 }
  end

  context 'can initialize from a time' do
    let(:time_on_day) { DateTime.new(2014, 2, 3, 4, 52).utc }
    it { should == Timely::TimeOfDay.from_time(time_on_day) }
  end
end
