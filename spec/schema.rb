# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :seasonals do |t|
    t.date :boundary_start, :boundary_end
    t.integer :season_id
  end

  create_table :seasons do |t|
    t.string :name
  end

  create_table :date_groups do |t|
    t.integer :season_id, :weekdays_bit_array
    t.date :start_date, :end_date
  end
end
