class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.string  :name
      t.string  :city
      t.string  :url
      t.string  :word
      t.integer :user_id

      t.timestamps
    end
  end
end
