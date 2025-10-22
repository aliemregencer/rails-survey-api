class CreateSurveys < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :surveys, :title
  end
end
