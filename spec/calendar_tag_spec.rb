require 'spec_helper'

class ActionViewTest
  include Timely::ActionViewHelpers::FormTagHelper
end

describe Timely::ActionViewHelpers do
  subject { ActionViewTest.new }
  let(:string) { double(:string) }
  let(:date) { Date.new(2000, 12, 25) }
  before {
    date.should_receive(:to_s).with(:calendar).and_return('25-12-2000')
    Timely.stub(:current_date).and_return(date)
  }

  it 'should generate calendar tags' do
    string.should_receive(:html_safe)
    subject.should_receive(:tag).with(:input,
      :id    => 'test',
      :class => 'datepicker input-small',
      :size  => 10,
      :maxlength => 10,
      :name  => 'test',
      :type  => 'text',
      :value => '25-12-2000'
    ).and_return(string)
    subject.calendar_tag :test
  end
end
