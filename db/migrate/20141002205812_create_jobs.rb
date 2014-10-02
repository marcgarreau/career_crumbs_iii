class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :user_id
      t.string :company
      t.text :description
      t.string :location
      t.integer :linkedin_id

      t.timestamps
    end
  end
end
