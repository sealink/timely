require 'spec_helper'

require 'timely/rails/period'

describe Timely::Period do
  let(:time) { DateTime.new(2000, 1, 1, 12, 0, 0) }
  let(:period_after_time) { DateTime.new(2000, 1, 1, 12, 2, 0) }
  subject(:period) { Timely::Period.new(2, :minutes) }

  it 'should work' do
    expect(period.after(time)).to eq period_after_time
  end

  specify do
    expect(period.to_s).to eq '2 minutes'
  end
end
