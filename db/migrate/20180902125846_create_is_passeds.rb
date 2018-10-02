class CreateIsPasseds < ActiveRecord::Migration[5.0]
  def change
    create_table :is_passeds do |t|
			t.references :user
			t.string :company_name
			t.string :work_name
			t.string :deadline
			t.string :site_name
			t.string :passed
			t.string :startdate
			t.string :company_site
      t.timestamps
    end
  end
end
