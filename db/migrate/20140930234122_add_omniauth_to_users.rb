class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :headline, :string
    add_column :users, :industry, :string
    add_column :users, :pic_url, :string
  end
end
