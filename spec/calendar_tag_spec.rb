require 'spec_helper'

class ActionViewTest
  include Timely::ActionViewHelpers::FormTagHelper
end

describe Timely::ActionViewHelpers do
  subject { ActionViewTest.new }
  let(:string) { double(:string) }
  before { Timely.stub(:current_date).and_return(Date.new(2000, 12, 25)) }

  it 'should generate calendar tags' do
    string.should_receive(:html_safe)
    subject.should_receive(:tag).with(:input,
      :id    => 'test',
      :class => %w(datepicker input-small),
      :size  => 10,
      :maxlength => 10,
      :name  => 'test',
      :type  => 'text',
      :value => '25-12-2000'
    ).and_return(string)
    subject.calendar_tag :test
  end
end
