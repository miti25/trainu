class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :recipe
      t.references :user

      t.timestamps
      t.index [:user_id, :recipe_id], unique: true
    end
  end
end
