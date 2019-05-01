class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.string :twitter_url, null: false
      t.string :twitter_username, null: true
      t.string :twitter_description, null: true

      t.timestamps null: false
    end
  end
end
