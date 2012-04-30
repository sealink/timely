ActiveRecord::Schema.define(:version => 1) do
  create_table :seasons do |t|
    t.string :name
  end

  create_table :date_groups do |t|
    t.integer :season_id, :weekdays_bit_array
    t.date :start_date, :end_date
  end
end

