require 'spec_helper'

describe String do
  it "should convert to date" do
    "10-2010-01".to_date('%d-%Y-%m').should eql Date.parse("2010-01-10")
  end

  # Spec currently doesn't work
  #it 'should handle rails date formats' do
  #  Date::DATE_FORMATS[:db] = '%m-%Y-%d'
  #  "01-2010-10".to_date(:db).should eql Date.parse("2010-01-10")
  #end
end
