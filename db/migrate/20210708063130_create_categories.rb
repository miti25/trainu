class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :recipe, foreign_key: true, index: true

      t.timestamps
    end
  end
end
