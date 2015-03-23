class CreateMyscores < ActiveRecord::Migration
  def change
    create_table :myscores do |t|
      t.string :question
      t.integer :answer
      t.integer :level
      t.boolean :result
      t.integer :score
      t.references :profile, index: true

      t.timestamps
    end
  end
end
