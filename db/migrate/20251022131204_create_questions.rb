class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :survey, null: false, foreign_key: true
      t.text :text
      t.integer :question_type, default: 0

      t.timestamps
    end
  end
end
