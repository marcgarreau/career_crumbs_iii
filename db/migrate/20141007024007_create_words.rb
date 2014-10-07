class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :value
      t.integer :user_id
      t.integer :occurrences
    end
  end
end
