class CreateQuestionsLists < ActiveRecord::Migration[5.0]
  def change
    create_table :questions_lists do |t|
			t.string :question
      t.timestamps
    end
  end
end
