class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
			t.references :user
			t.string :date
			t.string :title
			t.string :content
      t.timestamps
    end
  end
end
