class CreateHowtos < ActiveRecord::Migration[5.2]
  def change
    create_table :howtos do |t|
      t.text :description, limit: 200
      t.string :image
      t.references :recipe, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
