# frozen_string_literal: true

require 'spec_helper'

class ActionViewTest
  include Timely::ActionViewHelpers::FormTagHelper
end

describe Timely::ActionViewHelpers do
  subject { ActionViewTest.new }
  let(:string) { double(:string) }
  let(:date) { Date.new(2000, 12, 25) }
  before do
    expect(Timely).to receive(:current_date).and_return(date)
  end

  it 'should generate calendar tags' do
    expect(string).to receive(:html_safe)
    expect(subject).to receive(:tag).with(:input,
                                          id: 'test',
                                          class: 'datepicker',
                                          size: 10,
                                          maxlength: 10,
                                          name: 'test',
                                          type: 'text',
                                          value: '2000-12-25').and_return(string)
    subject.calendar_tag :test
  end
end
