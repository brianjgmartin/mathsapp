class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :answer
      t.integer :level
      t.boolean :result
      t.integer :stdans
      t.references :user, index: true

      t.timestamps
    end
  end
end
