class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :survey, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :answer_value

      t.timestamps
    end
  end
end
