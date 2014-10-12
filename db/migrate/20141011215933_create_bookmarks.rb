class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false
      t.references :bookmarkable, null: false, polymorphic: true
    end

    add_index :bookmarks, [:user_id, :bookmarkable_id, :bookmarkable_type], unique: true, name: 'bookmarks_index'
  end
end
