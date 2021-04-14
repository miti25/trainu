class ChangeRecipesWordsLimit < ActiveRecord::Migration[5.2]
  def up
    change_column :recipes, :name, :string, limit: 30
    change_column :recipes, :description, :text, limit: 200
  end
  def down
    change_column :recipes, :name, :string
    change_column :recipes, :description, :text
  end
end
