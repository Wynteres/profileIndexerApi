class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.string :twitterUrl, null: false
      t.string :twitterUsername, null: true
      t.string :twitterDescription, null: true

      t.timestamps null: false
    end
  end
end
