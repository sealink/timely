# frozen_string_literal: true

require 'timely/time_since'

require 'timecop'

describe Timely::TimeSince do
  before do
    Timecop.freeze(DateTime.new(2000, 1, 10, 12, 0, 42))
  end
  after { Timecop.return }

  context '42 seconds ago' do
    subject(:time) { DateTime.new(2000, 1, 10, 12, 0, 0) }
    its(:seconds_since) { should eq 42 }
    its(:minutes_since) { should eq 0 }
    its(:hours_since) { should eq 0 }
  end

  context 'a day ago' do
    subject(:time) { DateTime.new(2000, 1, 9, 12, 0, 42) }
    its(:seconds_since) { should eq 24 * 60 * 60 }
    its(:minutes_since) { should eq 24 * 60 }
    its(:hours_since) { should eq 24 }
  end
end
