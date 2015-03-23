class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :level, default: 1
      t.integer :score, default: 0
      t.references :profile, index: true

      t.timestamps
    end
  end
end
